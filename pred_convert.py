import sys
import json
import os
import csv

with open(sys.argv[1], 'r', encoding='ascii') as f:
    data = json.load(f)

os.makedirs(os.path.dirname(sys.argv[2]), exist_ok=True)

with open(sys.argv[2], 'w', encoding='utf-8') as csv_f:
    writer = csv.writer(csv_f)
    writer.writerow(['id', 'answer'])
    for key,value in data.items():
        writer.writerow([key, value])    

