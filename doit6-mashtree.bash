#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------
# Running mashtree...
# ------------------------------------------------------------------------

echo 1>&2 '# Running mashtree...'

rm -rf ${MASHTREE} ${DATA}/mashtree.tsv
mkdir -p ${MASHTREE}

mashtree \
    --numcpus ${THREADS} \
    --outmatrix ${MASHTREE}/mashtree.tsv \
    --outtree ${MASHTREE}/mashtree.tsv \
    ${GENOMES}/*.fna \

cp --archive ${MASHTREE}/mashtree.tsv ${DATA}

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

