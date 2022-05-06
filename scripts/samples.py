import pandas as pd
from pathlib import Path
import os

data_dir = Path.cwd() / "../data/"
#print(os.listdir(data_dir))

pathlist = data_dir.glob('*.fastq.gz')

dic = {}
# old samples look like: ERR024609_tiny_2.fastq.gz
# samples on cluster look like: AS-529648-LR-53242_R1.fastq.gz
for path in pathlist:
    path_str = str(path)
    sample = os.path.basename(path).split('_')[0]
    if path_str.split("_")[-1] == "R1.fastq.gz":
        path_2 = "_".join(path_str.split("_")[:-1]) + "_R2.fastq.gz"
        path_tup = (sample, path_str, path_2)
    
    if sample not in dic:
        dic[sample] = path_tup

df = pd.DataFrame.from_dict(dic, orient='index')
#print(df)

df.to_csv('sample.tsv', sep="\t", index=False, header= ["samples", "fq1", "fq2"])
    
