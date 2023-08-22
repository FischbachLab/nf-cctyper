#!/bin/bash -x

set -e
set -u
set -o pipefail

START_TIME=$SECONDS
export PATH="/opt/conda/bin:${PATH}"

LOCAL=$(pwd)

# s3 inputs from env variables
GENOME_NAME=$1
GENOME_S3PATH=$2
PROJECT=$3
S3OUTDIR=$4

# Setup directory structure
OUTPUTDIR=${LOCAL}/tmp_$( date +"%Y%m%d_%H%M%S" )
LOCAL_OUTPUT="${OUTPUTDIR}/Sync"
LOCAL_GENOME="${OUTPUTDIR}/genomes"

GENOME_LOCALPATH="${LOCAL_GENOME}/$GENOME_NAME.fasta"
S3OUTPUTPATH="${S3OUTDIR}/$PROJECT/$GENOME_NAME"

mkdir -p "${OUTPUTDIR}" "${LOCAL_GENOME}"
trap '{ rm -rf ${OUTPUTDIR} ; exit 255; }' 1

# Download the genome from S3:
aws s3 cp --quiet "${GENOME_S3PATH}" "${GENOME_LOCALPATH}"

echo "**************************"
echo "CCTyper: Automatic detection and subtyping of CRISPR-Cas operons"
echo "**************************"

# Run CCTyper:
cctyper \
    --threads 16 \
    --no_plot \
    --prodigal single \
    --circular \
    "${GENOME_LOCALPATH}" \
    "${LOCAL_OUTPUT}"


######################### HOUSEKEEPING #############################
DURATION=$((SECONDS - START_TIME))
hrs=$(( DURATION/3600 )); mins=$(( (DURATION-hrs*3600)/60)); secs=$(( DURATION-hrs*3600-mins*60 ))
printf 'This AWSome pipeline took: %02d:%02d:%02d\n' $hrs $mins $secs
############################ PEACE! ################################
## Sync output
aws s3 sync "${LOCAL_OUTPUT}" "${S3OUTPUTPATH}"
# rm -rf "${OUTPUTDIR}"
