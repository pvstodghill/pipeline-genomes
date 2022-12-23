#! /bin/bash

set -e

NAME=pipeline-genomes

CONDA_PREFIX=$(dirname $(dirname $(type -p conda)))
. "${CONDA_PREFIX}/etc/profile.d/conda.sh"

PACKAGES=
#PACKAGES+=" pip"

PACKAGES+=" busco"
PACKAGES+=" mashtree"
PACKAGES+=" ncbi-datasets-cli"
PACKAGES+=" prokka"
PACKAGES+=" pyani"

if [ "$(type -p mamba)" ] ; then
    _conda="mamba --no-banner"
else
    _conda=conda
fi

function __ {
    echo + "$@"
    eval "$@"
}

if [ "$1" = -f ] ; then
    __ conda env remove -y --name ${NAME}
fi
if [ ! -d ${CONDA_PREFIX}/envs/${NAME} ] ; then
    __ conda create -y --name ${NAME}
fi
__ conda activate ${NAME}

__ $_conda install -y ${PACKAGES}

# __ pip install FIXME
