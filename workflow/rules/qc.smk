rule fastqc:
    input:
        lambda wildcards: samples.at[wildcards.sample, 'fq1'] if wildcards.i == "1" else samples.at[wildcards.sample, 'fq2']
    output:
        html = "results/qc/fastqc/{sample}_{i}.html",
        zip = "results/qc/fastqc/{sample}_{i}_fastqc.zip"
    log:
        "logs/fastqc/{sample}_{i}.log"
    conda:
        "../envs/env.yaml"
    wrapper:
        "v1.4.0/bio/fastqc"


# rule trimmatic:
#     input:
#         mate1= lambda wildcards: samples.at[wildcards.sample, 'fq1'],
#         mate2= lambda wildcards: samples.at[wildcards.sample, 'fq2']
#     output:
#         r1="results/trimmed/{sample}_1P.fq.gz",
#         r2="results/trimmed/{sample}_2P.fq.gz",
#         # reads where trimming entirely removed the mate
#         r1_unpaired="results/trimmed/{sample}_1U.fq.gz",
#         r2_unpaired="results/trimmed/{sample}_2U.fq.gz"
#     log:
#         "logs/trimmomatic/{sample}.log"
#     params:
#         base = lambda wildcards: f"results/trimmed/{wildcards.sample}.fq.gz",
#         adapter = config["adapter"]
#     threads:
#         4
#     conda:
#         "../envs/env.yaml"
#     shell:
#         "trimmomatic PE -threads {threads} {input.mate1} {input.mate2} -baseout {params.base} ILLUMINACLIP:{params.adapter}:2:30:10 2> {log}"


# rule fastqc_trim:
#     input:
#         "results/trimmed/{sample}_{i}{p}.fq.gz"
#     output:
#         html = "results/qc/fastqc_trim/{sample}_{i}{p}.html",
#         zip = "results/qc/fastqc_trim/{sample}_{i}{p}_fastqc.zip"
#     log:
#         "logs/fastqc_trim/{sample}_{i}{p}.log"
#     conda:
#         "../envs/env.yaml"
#     wrapper:
#         "v1.4.0/bio/fastqc"


# rule qualimap:
#     input:
#         "results/bam_sorted/{sample}_sorted.bam" 
#     output:
#         "results/qc/qualimap/{sample}/qualimapReport.html"
#     log:
#         "logs/qualimap/{sample}.log"
#     params:
#         outdir = "results/qc/qualimap/{sample}"
#     conda:
#         "../envs/env.yaml"
#     shell:
#         "qualimap bamqc -bam {input} -outdir {params.outdir}"


rule multiqc:
    input:
        html = expand("results/qc/fastqc/{sample}_{i}.html", sample = list(samples.index), i =["1","2"]),
        zip = expand("results/qc/fastqc/{sample}_{i}_fastqc.zip", sample = list(samples.index), i =["1","2"]),
        #html_trim = expand("results/qc/fastqc_trim/{sample}_{i}{p}.html", sample = list(samples.index), i = ["1", "2"], p = ["P", "U"]),
        #zip_trim = expand("results/qc/fastqc_trim/{sample}_{i}{p}_fastqc.zip", sample = list(samples.index), i = ["1", "2"], p = ["P", "U"]),
        #html_quali = expand("results/qc/qualimap/{sample}/qualimapReport.html", sample = list(samples.index))
    output:
        "results/qc/multiqc_report.html"
    log:
        "logs/multiqc.log"
    conda:
        "../envs/env.yaml"
    shell:
        "multiqc ./results/qc -o results/qc 2> {log}"