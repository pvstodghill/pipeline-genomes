#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

rm -rf ${PROKKA}
mkdir -p ${PROKKA}

# ------------------------------------------------------------------------
# Run prokka to reannotate genomes
# ------------------------------------------------------------------------

PROKKA_ARGS=
PROKKA_ARGS+=" --prefix output"
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
PROKKA_ARGS+=" --compliant" # for Panaroo
# PROKKA_ARGS+=" --rfam"
PROKKA_ARGS+=" --cpus ${THREADS}"

# ------------------------------------------------------------------------

cat ${RAW}/_metadata_.tsv | (
    while IFS=$'\t' read ACCESSION FNAME SOURCE ORGANISM STRAIN LEVEL DATE ; do

	if [ "${ACCESSION}" = "Accession" ] ; then
	    continue
	fi
	if [ -e "${RAW}/${FNAME}.faa" -a -z "$FORCE_REANNOTATE" ] ; then
	    continue
	fi

	SAFE_STRAIN="$(echo "$STRAIN" | sed -r -e 's/[^A-Za-z0-9_-]+//g')"

	echo 1>&2 "# Running Prokka: $FNAME"

	OUTPUT=${PROKKA}/${FNAME}_prokka

	prokka ${PROKKA_ARGS} \
	     --outdir ${OUTPUT} \
	     --strain ${SAFE_STRAIN} \
	     --locustag ${SAFE_STRAIN}_prokka \
	     ${RAW}/${FNAME}.fna

    done
)

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

