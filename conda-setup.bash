#! /bin/bash

set -e

CONDA_PREFIX=$(dirname $(dirname $(type -p conda)))
. "${CONDA_PREFIX}/etc/profile.d/conda.sh"

PACKAGES=

PACKAGES+=" ncbi-datasets-cli"
PACKAGES+=" prokka"
PACKAGES+=" busco"

set -x

conda env remove -y --name pipeline-genomes
conda create -y --name pipeline-genomes
conda activate pipeline-genomes

conda install -y ${PACKAGES}

pip install pyparanoid
