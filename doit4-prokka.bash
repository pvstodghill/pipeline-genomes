#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

if [ -z "${PIPELINE_RESTART}" ] ; then
    rm -rf ${PROKKA}
fi
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
    while IFS=$'\t' read NAME ACCESSION SOURCE ORGANISM STRAIN LEVEL DATE ; do

	if [ "${NAME}" = "Name" ] ; then
	    continue
	fi
	if [ -e "${RAW}/${NAME}.faa" -a -z "$FORCE_REANNOTATE" ] ; then
	    continue
	fi

	SAFE_STRAIN="$(echo "$STRAIN" | sed -r -e 's/[^A-Za-z0-9_-]+//g')"
	SAFE_ACCESSION="$(echo "$ACCESSION" | sed -r -e 's/[^A-Za-z0-9_.-]+//g')"

	OUTPUT=${PROKKA}/${NAME}_prokka

	if [ -e ${OUTPUT}/output.gbk ] ; then
	    echo 1>&2 "# Skipping: $NAME"
	    continue
	fi

	echo 1>&2 "# Running Prokka: $NAME"
	rm -rf ${OUTPUT}

	prokka ${PROKKA_ARGS} \
	     --outdir ${OUTPUT} \
	     --strain ${SAFE_STRAIN} \
	     ${RAW}/${NAME}.fna

	# --locustag ${SAFE_ACCESSION}_prokka

    done
)

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

