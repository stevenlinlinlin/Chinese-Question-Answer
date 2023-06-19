# Chinese Question Answer
This task can be decomposed into 2 tasks:
- Context selection: determine which context is relevant.
- Span selection: determine the start and end position of the answer span in the context.

# Package
```
pip install -r requirements.txt
```

# Data
## data format
### context.json
- list of short paragraphs
- example:
    ```json
    [
        "context1",
        "context2",
        "context3"
    ]
    ```
### questions.json
- example:
    ```json
    {
        "id": "0",
        "question": "question",
        "paragraphs": ["id1", "id2", "id3", "id4"],
        "relevant": "id3",
        "answer": { "text": "answer", "start": 0}
    }
    ```

## data convert format
change train, eval, and test data file format from list to dict
```
python data_convert.py <input data file> <output data file>
```
for example:
```
python data_convert.py ./data/train.json ./tmp/train.json
```

# Context Selection
## Training
```
python run_mc.py \
  --do_train \
  --do_eval \
  --model_name_or_path <model name>\
  --output_dir  <output path> \
  --train_file <train data path> \
  --validation_file <valid data path> \
  --context_file <context.json path> \
  --cache_dir ./cache/mc \
  --pad_to_max_length \
  --max_seq_length 512 \
  --learning_rate 3e-5 \
  --num_train_epochs 1 \
  --warmup_ratio 0.1 \
  --per_gpu_train_batch_size 1 \
  --gradient_accumulation_steps 2 \
  --overwrite_output_dir \
```
- model_name_or_path: [huggingface models](https://huggingface.co/models), ex. bert-base-chinese, bert-large-chinese, hfl/chinese-roberta-wwm-ext-large
- model weights will be saved in output_dir, ex. ./roberta_large/mc/

## Testing
```
python run_mc.py \
  --do_predict \
  --model_name_or_path <model path> \
  --output_dir <output path> \
  --test_file <test path> \
  --context_file <contest.json path> \
  --output_file <predict output path> \
  --pad_to_max_length \
  --max_seq_length 512 \
```
- model name or path: path to the model weights directory, ex. ./roberta_large/mc/
- output_file: path to the predict output 

# Question Answer
## Training
```
python run_qa.py \
  --do_train \
  --do_eval \
  --model_name_or_path <model name> \
  --output_dir  <output path> \
  --train_file <train path> \
  --validation_file <valid path> \
  --context_file <context.json path> \
  --cache_dir ./cache/qa \
  --per_gpu_train_batch_size 10 \
  --gradient_accumulation_steps 8 \
  --per_gpu_eval_batch_size 10 \
  --eval_accumulation_steps  8\
  --learning_rate 3e-5 \
  --num_train_epochs 10 \
  --max_seq_length 512 \
  --doc_stride 128 \
  --warmup_ratio 0.1 \
  --overwrite_output_dir \
```
- model_name_or_path: [huggingface models](https://huggingface.co/models), ex. bert-base-chinese, bert-large-chinese, hfl/chinese-roberta-wwm-ext-large
- model weights will be saved in output_dir, ex. ./roberta_large/qa/

## Testing
```
python run_qa.py \
  --do_predict \
  --model_name_or_path <model path> \
  --output_dir <output path> \
  --test_file <test path> \
  --context_file <context.json path> \
  --pad_to_max_length \
  --max_seq_length 512 \
  --doc_stride 128 \
  --per_gpu_eval_batch_size 10 \
```
- model name or path: path to the model weights directory, ex. ./roberta_large/qa/
- output_dir: path to the predict output

## Prediction format convert
change prediction output format from ascii to utf-8
```
python pred_convert.py \
<predict output from model> \
<final predict output format path> \
```

# Inferencing expample with bash script
make sure you have the correct model weights in run.sh
```bash
bash run.sh <context json path> <test json path>
```
- multiple choice model: ./bert_large/mc/
- question answer model: ./roberta_large/qa/