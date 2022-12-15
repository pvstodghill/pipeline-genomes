#! /bin/bash

set -e

NAME=pipeline-genomes

CONDA_PREFIX=$(dirname $(dirname $(type -p conda)))
. "${CONDA_PREFIX}/etc/profile.d/conda.sh"

PACKAGES=
#PACKAGES+=" pip"

PACKAGES+=" ncbi-datasets-cli"
PACKAGES+=" prokka"
PACKAGES+=" busco"

if [ "$(type -p mamba)" ] ; then
    _conda="mamba --no-banner"
else
    _conda=conda
fi

set -x

conda env remove -y --name ${NAME}
conda create -y --name ${NAME}
conda activate ${NAME}

$_conda install -y ${PACKAGES}

#pip install FIXME
