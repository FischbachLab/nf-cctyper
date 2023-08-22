FROM mambaorg/micromamba:latest

RUN micromamba install -n base -c conda-forge -c bioconda -c russel88 cctyper awscli -y \
    && micromamba clean --all --yes

USER root:root
RUN mkdir -p /work
WORKDIR /work
