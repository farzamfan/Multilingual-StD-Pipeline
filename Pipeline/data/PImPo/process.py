import csv, json, sys

def pre_process_single(text, id):
    return text.split(" ")

def readcsv(filename, delim, split):
    dataset = []
    with open(filename, 'r', encoding='utf-8', errors="surrogateescape") as f:
        reader = csv.reader(f, delimiter=delim)
        for i, row in enumerate(reader):
            if split == 'test':
                dataset.append([i, row[1], row[2], row[3]])
            else:
                # removing the party name (and therefore the country information
                dataset.append([split + "_" + str(i)] + row[1:4])
    return dataset[1:]

train_dataset = readcsv(sys.argv[1]+"/train.csv", ',', 'train')
test_dataset = readcsv(sys.argv[1]+"/test.csv", ',', 'test')

prep_dataset = []

def append_dataset(dataset, split):
    val_num = len(dataset) * 0.8
    for i, data in enumerate(dataset):
        assert len(data) == 4
        if split == "train" and i > val_num:
            split = "valid"
        prep_dataset.append({'id': data[0],
                            'text': pre_process_single(data[1], ''),
                            'target': data[2],
                            'split': split,
                            'stance': data[3]
                        })

append_dataset(train_dataset, 'train')
append_dataset(test_dataset, "test")

fo = open(sys.argv[1]+"/data.json", "w+")
json.dump(prep_dataset, fo, indent=2,ensure_ascii=False)
fo.close()

