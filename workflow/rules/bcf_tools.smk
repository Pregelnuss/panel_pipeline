rule bcf_mpileup:
    input:
        ref = "reference/ref.fa",
        alignments = "results/bam_sorted/{sample}_sorted.bam",
        index="reference/ref.fa.fai" #TO CREATE WITH SAMTOOLS faidx
    output:
        pileup="results/pileups/{sample}.pileup.bcf",
    params:
        options="--max-depth 100 --min-BQ 15",
    log:
        "logs/bcftools_mpileup/{sample}.log",
    wrapper:
        "v1.4.0/bio/bcftools/mpileup"
