#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

rm -rf ${PROKKA}
mkdir -p ${PROKKA}

# ------------------------------------------------------------------------
# Run prokka to reannotate genomes
# ------------------------------------------------------------------------

PROKKA_ARGS=
PROKKA_ARGS+=" --prefix output"
PROKKA_ARGS+=" --cpus ${THREADS}"
PROKKA_ARGS+=" --quiet"
# requires signalp
# if [ "$PROKKA_GRAM" ] ; then
#     PROKKA_ARGS+=" --gram ${PROKKA_GRAM}"
# fi
if [ "$PROKKA_GENUS" ] ; then
    PROKKA_ARGS+=" --genus ${PROKKA_GENUS}"
fi
if [ "$PROKKA_SPECIES" ] ; then
    PROKKA_ARGS+=" --species ${PROKKA_SPECIES}"
fi
# PROKKA_ARGS+=" --rfam"
# PROKKA_ARGS+=" --addgenes"

# ------------------------------------------------------------------------

for FNA in ${GENOMES}/*.fna ; do
    STRAIN=$(basename $FNA .fna)
    if [ -e ${GENOMES}/$STRAIN.faa -a -z "$FORCE_REANNOTATE" ] ; then
	continue
    fi

    echo 1>&2 "# Running Prokka: $STRAIN"

    OUTPUT=${PROKKA}/${STRAIN}_prokka

    prokka ${PROKKA_ARGS} \
	   --outdir ${OUTPUT} \
	   --strain ${STRAIN} \
	   --locustag ${STRAIN}_prokka \
	   ${FNA}

    cp ${OUTPUT}/output.faa ${PROKKA}/${STRAIN}.faa
    cp ${OUTPUT}/output.fna ${PROKKA}/${STRAIN}.fna
    # cp ${OUTPUT}/output.gbk ${PROKKA}/${STRAIN}.gbk
    # cat ${OUTPUT}/output.gff \
    # 	| sed -e '/^##FASTA/,$d' \
    # 	> ${PROKKA}/${STRAIN}.gff

done

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

