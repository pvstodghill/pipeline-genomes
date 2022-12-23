#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------
# Running mashtree...
# ------------------------------------------------------------------------

echo 1>&2 '# Running mashtree...'

rm -rf ${MASHTREE}
mkdir -p ${MASHTREE}

mashtree \
    --numcpus ${THREADS} \
    --outmatrix ${MASHTREE}/matrix.tsv \
    --outtree ${MASHTREE}/tree.phy \
    ${GENOMES}/*.fna \

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

