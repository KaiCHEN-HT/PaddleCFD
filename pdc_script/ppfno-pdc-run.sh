
# 您可以在此文件中配置全局环境变量
# 您可以在此文件中运行train.py文件
#!/bin/bash
echo "TRAINER_GPU_CARD_COUNT: ${TRAINER_GPU_CARD_COUNT}"
gpus="0"
for (( i=1; i<${TRAINER_GPU_CARD_COUNT}; i++ ))
do
    gpus="${gpus},$i"
done

# standalone, single card
if [[ ${PADDLE_IS_LOCAL} = 1 && ${TRAINER_GPU_CARD_COUNT} = 1 ]]; then
    source /root/paddlejob/PaddleCFD/activate_and_cd.sh
    python -m paddle.distributed.launch --gpus 0 /root/paddlejob/PaddleCFD/examples/aerodynamic_drag_pred/ppfno/train.py train_input_path=/root/paddlejob/SAE-ppfno train_ratio=0.7 test_ratio=0.3 task_id=1 save_per_epoch=10 train_output_path=/root/paddlejob/workspace/env_run/output num_epochs=100 finetuning_epochs=51 save_eval_results=false

# standalone, multiple cards
elif [[ ${PADDLE_IS_LOCAL} = 1 && ${TRAINER_GPU_CARD_COUNT} -gt 1 ]]; then
    source /root/paddlejob/PaddleCFD/activate_and_cd.sh
    python -m paddle.distributed.launch --gpus ${gpus} /root/paddlejob/PaddleCFD/examples/aerodynamic_drag_pred/ppfno/train.py train_input_path=/root/paddlejob/SAE-ppfno train_ratio=0.7 test_ratio=0.3 task_id=1 save_per_epoch=10 train_output_path=/root/paddlejob/workspace/env_run/output num_epochs=100 finetuning_epochs=51 save_eval_results=false

# multiple nodes
elif [[ ${PADDLE_IS_LOCAL} != 1 ]]; then
    source /root/paddlejob/PaddleCFD/activate_and_cd.sh
    python -m paddle.distributed.launch --gpus ${gpus} --ips="${TRAINER_IP_LIST}" /root/paddlejob/PaddleCFD/examples/aerodynamic_drag_pred/ppfno/train.py train_input_path=/root/paddlejob/SAE-ppfno train_ratio=0.7 test_ratio=0.3 task_id=1 save_per_epoch=10 train_output_path=/root/paddlejob/workspace/env_run/output num_epochs=100 finetuning_epochs=51 save_eval_results=false
fi
