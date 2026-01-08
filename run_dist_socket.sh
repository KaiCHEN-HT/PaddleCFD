#!/bin/bash

# 机器 IP 列表 (主节点必须在第一位)
IPS="10.42.1.5,10.42.1.11,10.42.1.14,10.42.1.15"
MASTER_IP="10.42.1.5"
MASTER_PORT=59330
GPUS=0,1,2,3,4,5,6,7
NET_IFNAME="bond0"
MCCL_IB_HCA="mlx5_bond_0"

IFS=',' read -ra ADDR <<< "$IPS"
NNODES=${#ADDR[@]}

TRAIN_CMD="export GLOO_SOCKET_IFNAME=$NET_IFNAME && export MCCL_SOCKET_IFNAME=$NET_IFNAME && export MCCL_IB_DISABLE=1 && export MCCL_DEBUG=INFO && /opt/conda/bin/python -m paddle.distributed.launch --master=$MASTER_IP:$MASTER_PORT --ips=$IPS  --gpus=$GPUS --nnodes=$NNODES /opt/package/ppcfd/PaddleCFD/examples/aerodynamic_drag_pred/ppfno/train.py train_input_path=/home/train_dataset/ train_ratio=0.7 test_ratio=0.3 task_id=1 save_per_epoch=10 train_output_path=/home/train_output/ num_epochs=100 finetuning_epochs=51 save_eval_results=false"

# 遍历所有 IP，通过 SSH 启动容器内的训练进程
for i in "${!ADDR[@]}"; do
    HOST_IP=${ADDR[$i]}
    
    # 构造要在远程宿主机上执行的 Docker 命令
    REMOTE_CMD="docker run --device=/dev/infiniband --device=/dev/mxcd --device=/dev/dri --group-add video --rm --name PaddleCFD_Ranks${i} \
      -v /home/mx/baidu_chenkai/train_output:/home/train_output \
      --network=host \
      --shm-size 64g \
      iregistry.baidu-int.com/ai_4_fluid/ppfno:metax-32parallel-maca.3.1.0.5-py310-ubuntu22.04-amd64 \
      /bin/bash -lc \"$TRAIN_CMD\""

    # 在主节点上直接执行，在从节点上通过 SSH 远程执行
    if [ "$HOST_IP" == "$MASTER_IP" ]; then
        echo "Starting Master Node (${HOST_IP})..."
        eval "$REMOTE_CMD" & # 在后台启动主节点

	#【关键修改】添加等待机制，确保主节点有时间初始化完成
        echo "Waiting 10 seconds for Master Node to stabilize and listen on port ${MASTER_PORT}..."
        sleep 10s
        echo "Master Node should be ready. Proceeding to launch Worker Nodes."
    else
        echo "Starting Worker Node (${HOST_IP}) via SSH..."
	REMOTE_CMD_BKG="nohup $REMOTE_CMD > /dev/null 2>&1 &"
        # 注意: 需要确保您的 SSH 环境设置允许执行此远程命令
        ssh "$HOST_IP" "bash -c '$REMOTE_CMD_BKG'" &
    fi
done

# 等待所有后台进程完成 (可选，取决于您的需求)
wait
