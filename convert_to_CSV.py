import json
import csv
import re
import string

file = "prediction.json"

with open(file, 'r') as f:
    data = json.load(f)

header = ['Id','Answer']

ids = list(data)

def normalize_answer(s):
    """Lower text and remove punctuation, articles and extra whitespace."""

    def remove_articles(text):
        return re.sub(r'\b(a|an|the)\b', ' ', text)

    def white_space_fix(text):
        return ' '.join(text.split())

    def remove_punc(text):
        exclude = set(string.punctuation)
        return ''.join(ch for ch in text if ch not in exclude)

    def lower(text):
        return text.lower()

    return white_space_fix(remove_articles(remove_punc(lower(s))))

with open( "submission.csv", "w", encoding='utf-8', newline='') as csv_file:
    writer = csv.writer(csv_file, delimiter=',', quoting=csv.QUOTE_ALL)
    writer.writerow(header)

    for i in range(0, len(ids)):

        key =  ids[i]
        if(key != "scores"):
            ans = normalize_answer(str(data[key]))
            row = [int(key),ans]
            writer.writerow(row)
