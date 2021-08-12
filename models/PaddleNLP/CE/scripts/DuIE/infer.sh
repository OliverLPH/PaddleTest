cur_path=`pwd`
model_name=${PWD##*/}

echo "$model_name 模型训练阶段"
#取消代理
HTTPPROXY=$http_proxy
HTTPSPROXY=$https_proxy
unset http_proxy
unset https_proxy

#路径配置
root_path=$cur_path/../../
code_path=$cur_path/../../models_repo/examples/information_extraction/DuIE/
log_path=$root_path/log/$model_name/

if [ ! -d $log_path ]; then
  mkdir -p $log_path
fi

print_info(){
if [ $1 -ne 0 ];then
    cat ${log_path}/$2.log
    echo "exit_code: 1.0" >> ${log_path}/$2.log
else
    echo "exit_code: 0.0" >> ${log_path}/$2.log
fi
}

cd $code_path
python run_duie.py \
    --do_predict \
    --init_checkpoint ./checkpoints/$2/model_10000.pdparams \
    --predict_data_file ./data/test.json \
    --max_seq_length 128 \
    --batch_size 64 > $log_path/infer_$2_$1.log 2>&1

print_info $? infer_$2_$1
