rule sam_to_bam:
    input:
        "results/sam/{sample}.sam"
    output:
        "results/bam/{sample}.bam"
    threads:
        4
    conda:
        config["env_dir"]
    shell:
        "samtools view -b -o {output} {input} -@ {threads}"

rule sort:
    input:
        "results/bam/{sample}.bam"
    output:
        "results/bam_sorted/{sample}_sorted.bam"
    threads:
        4
    conda:
        config["env_dir"]
    shell:
        "samtools sort -o {output} {input} -@ {threads}"

rule index:
    input:
        "results/bam_sorted/{sample}_sorted.bam"
    output:
        "results/bam_sorted/{sample}_sorted.bam.bai"
    threads:
        4
    conda:
        config["env_dir"]
    shell:
        "samtools index {input} -@ {threads}"

rule stats:
    input:
        "results/bam_sorted/{sample}_sorted.bam",
        "results/bam_sorted/{sample}_sorted.bam.bai"
    output:
        "results/stats/{sample}.stats"
    conda:
        config["env_dir"]
    shell:
        "samtools idxstats {input[0]} > {output}" 