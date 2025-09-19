# paddle v2.4.0
################################## User Define Configuration ###########################
################################## Data Configuration ##################################

#attention: files for training should be put on afs
##the list contains all file locations should be specified here
fs_name="afs://baihua.afs.baidu.com:9902"
##ugi of afs
fs_ugi="pdcuser,pdcuser2020"

#the initial model path on afs used to init parameters
#init_model_path=
#the initial model path for pservers
#pserver_model_dir=
#which pass
#pserver_model_pass=
#example of above 2 args:
#if set pserver_model_dir to /app/paddle/models
#and set pserver_model_pass to 123
#then rank 0 will download model from /app/paddle/models/rank-00000/pass-00123/
#and rank 1 will download model from /app/paddle/models/rank-00001/pass-00123/, etc.
#the output directory on afs
output_path = "/user/pdcuser/paddle-platform/demo/quick_start_gpu/output"
# train_data_path="/user/pdcuser/paddle-platform/demo/quick_start_gpu/train_data"
# test_data_path="/user/pdcuser/paddle-platform/demo/quick_start_gpu/test_data"

FLAGS_rpc_deadline=3000000
NCCL_DEBUG=INFO
NCCL_IB_DISABLE=1
is_auto_split_data=0