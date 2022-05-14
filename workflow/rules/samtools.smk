rule sam_to_bam:
    input:
        "results/sam/{sample}.sam"
    output:
        "results/bam/{sample}.bam"
    log:
        "logs/samtools/view/{sample}.log"
    threads:
        4
    conda:
        "../envs/env.yaml"
    shell:
        "samtools view -b -o {output} {input} -@ {threads} 2> {log}"

rule sort:
    input:
        "results/bam/{sample}.bam"
    output:
        "results/bam_sorted/{sample}_sorted.bam"
    log:
        "logs/samtools/sort/{sample}.log"
    threads:
        4
    conda:
        "../envs/env.yaml"
    shell:
        "samtools sort -o {output} {input} -@ {threads} 2> {log}"

rule index:
    input:
        "results/bam_sorted/{sample}_sorted.bam"
    output:
        "results/bam_sorted/{sample}_sorted.bam.bai"
    log:
        "logs/samtools/index/{sample}.log"
    threads:
        4
    conda:
        "../envs/env.yaml"
    shell:
        "samtools index {input} -@ {threads} 2> {log}"

rule stats:
    input:
        "results/bam_sorted/{sample}_sorted.bam",
        "results/bam_sorted/{sample}_sorted.bam.bai"
    output:
        "results/stats/{sample}.stats"
    log:
        "logs/samtools/stats/{sample}.log"
    conda:
        "../envs/env.yaml"
    shell:
        "samtools idxstats {input[0]} > {output} 2> {log}" 