# convert test data to dict
python data_convert.py $2 ./tmp/test.json

# make file directory for predict tmp
mkdir pred_tmp

# Multiple Choice
python run_mc.py \
  --do_predict \
  --model_name_or_path ./bert_large/mc/ \
  --output_dir ./ckpt/ \
  --test_file ./tmp/test.json \
  --context_file $1 \
  --output_file ./pred_tmp/pred_mc.json \
  --pad_to_max_length \
  --max_seq_length 512 \

# Question Answer
python run_qa.py \
  --do_predict \
  --model_name_or_path ./roberta_large/qa/ \
  --output_dir ./pred_tmp/roberta_large \
  --test_file ./pred_tmp/pred_mc.json \
  --context_file $1\
  --pad_to_max_length \
  --max_seq_length 512 \
  --doc_stride 128 \
  --per_gpu_eval_batch_size 10 \

# convert predict result from ascii to utf-8
python pred_convert.py ./pred_tmp/roberta_large/predict_predictions.json $3

# delete pred_tmp file, ckpt empty file, and tmp data file 
rm -rf pred_tmp
rm -rf ckpt
rm -rf tmp