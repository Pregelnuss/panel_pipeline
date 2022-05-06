import pandas as pd
from pathlib import Path
import os

# assuming the fastq files are one folder up from scripts and then down in data
# maybe it's the easiest if the fastq files are symlinked, so no copying is needed

data_dir = Path.cwd() / "../data/"
#print(os.listdir(data_dir))

# get all files with right ending
pathlist = data_dir.glob('*.fastq.gz')

# create new dictionary
dic = {}

# samples on cluster look like: AS-529648-LR-53242_R1.fastq.gz
# if they look different, the splitting below must be changed
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

# write file which is then in the workflow being used for mapping
df.to_csv('sample.tsv', sep="\t", index=False, header= ["samples", "fq1", "fq2"])
    
