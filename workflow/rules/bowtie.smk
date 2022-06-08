ref_ref = str(Path("results") / "reference" / ref_file.stem)

def bow_speed_flag(bui):
    if bui == "very-fast":
        return "--very-fast"
    elif bui == "fast":
        return "--fast"
    elif bui == "sensitive":
        return "--sensitive"
    else:
        return "--very-sensitive"

rule bowtie2_build:
    input:
        ref = ref_file
    output:
        multiext(
            ref_ref,
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
        ref = ref_ref
    threads:
        4
    conda:
        "../envs/env.yaml"
    shell:
        "bowtie2-build {input} {params.ref} -p {threads} 2> {log}"

rule bowtie2:
    input:
        r1= lambda wildcards: samples.at[wildcards.sample, 'fq1'], 
        r2= lambda wildcards: samples.at[wildcards.sample, 'fq2'],
        #r1="results/trimmed/{sample}_1P.fq.gz",
        #r2="results/trimmed/{sample}_2P.fq.gz",
        idx = multiext(
            ref_ref,
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
        N = config["bow_N"],
        speed = bow_speed_flag(config["bow_speed"]),
        ref = ref_ref
    threads:
        4
    conda:
        "../envs/env.yaml"
    shell:
        "bowtie2 -x {params.ref} -1 {input.r1} -2 {input.r2} -N {params.N} {params.speed} -S {output} -p {threads} 2> {log}"
