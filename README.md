README
====================

## CCTyper: Automatic detection and subtyping of CRISPR-Cas operons 

## References:

## Seedfile example
### Note that the seedfile is a CSV (comma-separated values) file with header
### The format of the seedfile is genome_name,genome_path

```{bash}
sampleName,file_path
Alistipes-putredinis-DSM-17216,s3://maf-versioned/ninjamap/Index/HCom2_20221117/fasta/Alistipes-putredinis-DSM-17216-MAF-2.fna
```

## A sample batch submission script

```{bash}
aws batch submit-job \
  --job-name nf-cctyper \
  --job-queue priority-maf-pipelines \
  --job-definition nextflow-production \
  --container-overrides command="s3://nextflow-pipelines/nf-cctyper, \
"--project", "TEST", \
"--seedfile", "s3://genomics-workflow-core/Results/cctyper/230816_seedfile.tsv", \
"--outdir", "s3://genomics-workflow-core/Results/cctyper" "
```

### The final output file path:
```{bash}
s3://genomics-workflow-core/Results/cctyper/TEST/
```
