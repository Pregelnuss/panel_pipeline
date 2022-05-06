import pandas as pd
from pathlib import Path
import os

configfile: "config/config.yaml"

os.chdir(config["workdir"])

rpk_script = Path(config["workdir"]) / "scripts" / "calc_rpk.py"

samples = pd.read_csv(config["samples"], index_col = "samples", sep = '\t')

rule all:
    input: 
        expand("results/stats/{sample}.stats_aug", sample = list(samples.index))

rule rpk:
    input:
        "results/stats/{sample}.stats"
    output:
        "results/stats/{sample}.stats_aug"
    shell:
        "python3 {rpk_script} {input}"

include: "rules/bowtie.smk"
include: "rules/samtools.smk"