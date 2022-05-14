import pandas as pd
from pathlib import Path
import os

# function to create a tsv from data given in data folder.
# this is only executed if the user didnt provide a tsv an its allowed to be executed by the config. 

# this works only if the data looks like this: AAAAAA_BBB_1.fastq.gz and AAAAAA_BBB_2.fastq.gz for paired end

# take the paths for all files wich end wirh 1.fastq.gz, since those are identical to the ones with 2
# for column sample take the basename only, which is the name before the first "_"
# take the path from r1 and replace r1 with r2 to get path for r2 as well
# if sample not known yet, put in dictionary: sample | path for r1 | path for r2
# save dataframe as samples
def read_sample(data_dir):
    pathlist = Path(data_dir).glob('*1.fastq.gz')
    dic = {}

    for path in pathlist:
        path_str = str(path)
        sample = os.path.basename(path).split('_')[0]
        path_2 =  path_str.replace("1.fastq.gz", "2.fastq.gz")
        if sample not in dic:
            dic[sample] = (sample, path_str, path_2)

    samples = pd.DataFrame.from_dict(dic, orient='index', columns=["sample", "fq1", "fq2"])
    return samples