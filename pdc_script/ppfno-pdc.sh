nvidia-docker run --privileged --rm --name ppfno-pdc-test \
--network=host \
--shm-size 64g \
iregistry.baidu-int.com/ai_4_fluid/ppfno:ppfno-pdc-paddle-v3.1-gcc11.4-cuda11.8-cudnn8.9-python3.10 \
/bin/bash -c "source activate_and_cd.sh && python -m paddle.distributed.launch --gpus=0,4 train.py train_input_path=/root/paddlejob/SAE-ppfno train_ratio=0.7 test_ratio=0.3 task_id=1 save_per_epoch=10 train_output_path=/root/paddlejob/workspace/env_run/output num_epochs=100 finetuning_epochs=51 save_eval_results=false"


nvidia-docker run --privileged --name ppfno-pdc-test \
--network=host -it \ 
--shm-size 64g \
iregistry.baidu-int.com/ai_4_fluid/ppfno:ppfno-pdc-paddle-v3.1-gcc11.4-cuda11.8-cudnn8.9-python3.10 \
/bin/bash 

nvidia-docker run --privileged --name ppfno-pdc-test --network=host -it  --shm-size 64g iregistry.baidu-int.com/ai_4_fluid/ppfno:ppfno-pdc-paddle-v3.1-gcc11.4-cuda11.8-cudnn8.9-python3.10 /bin/bash


python -m paddle.distributed.launch --gpus=6 train.py train_input_path=/home/Paddle-AeroSim-DataModel/pre_output train_ratio=0.5 test_ratio=0.5 task_id=1 save_per_epoch=10 train_output_path=/home/Paddle-AeroSim-DataModel/train_output_v1_small num_epochs=50 finetuning_epochs=21 save_eval_results=false