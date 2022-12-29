#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------
# Running mashtree...
# ------------------------------------------------------------------------

echo 1>&2 '# Running mashtree...'

rm -rf ${MASHTREE} ${DATA}/mashtree.tsv
mkdir -p ${MASHTREE}/tmp

mashtree \
    --numcpus ${THREADS} \
    --outmatrix ${MASHTREE}/mashtree.tsv \
    --outtree ${MASHTREE}/mashtree.dnd \
    --mindepth 0 \
    --tempdir ${MASHTREE}/tmp \
    ${RAW}/*.fna \

mashtree_cluster.pl \
    --threshold 0.05 \
    ${MASHTREE}/tmp/distances.sqlite \
    | sort > ${MASHTREE}/clusters.txt



cp --archive ${MASHTREE}/mashtree.tsv ${DATA}
cp --archive ${MASHTREE}/clusters.txt ${DATA}

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

