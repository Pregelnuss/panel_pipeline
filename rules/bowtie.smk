print(config["env_dir"])
rule bowtie2_build:
    input:
        ref = "reference/ref.fa"
    output:
        multiext(
            "reference/ref",
            ".1.bt2",
            ".2.bt2",
            ".3.bt2",
            ".4.bt2",
            ".rev.1.bt2",
            ".rev.2.bt2",
        ),
    log:
        "logs/bowtie2_build/build.log",
    params:
        extra="",  # optional parameters
    threads:
        4
    conda:
        config["env_dir"]
    shell:
        "bowtie2-build {input} reference/ref -p {threads}"

rule bowtie2:
    input:
        a= lambda wildcards: samples.at[wildcards.sample, 'fq1'], 
        b= lambda wildcards: samples.at[wildcards.sample, 'fq2'],
        idx=multiext(
            "reference/ref",
            ".1.bt2",
            ".2.bt2",
            ".3.bt2",
            ".4.bt2",
            ".rev.1.bt2",
            ".rev.2.bt2",
        ),
    output:
        "results/sam/{sample}.sam",
    log:
        "logs/bowtie2/{sample}.log",
    params:
        N=config["bow_N"],
        vfast=config["bow_vfast"]
    threads:
        4  # Use at least two threads
    conda:
        config["env_dir"]
    shell:
        "bowtie2 -x reference/ref -1 {input.a} -2 {input.b} {params.N} {params.vfast} -S {output} -p {threads}"
