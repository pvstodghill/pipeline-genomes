#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

if [ -z "${PIPELINE_RESTART}" ] ; then
    rm -rf ${REANNOTATED}
fi
mkdir -p ${REANNOTATED}

# ------------------------------------------------------------------------
# reannotate genomes
# ------------------------------------------------------------------------

# Setup Prokka args (if we use it)

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
    while IFS=$'\t' read ACCESSION SOURCE ORGANISM STRAIN LEVEL DATE ; do

	# ------------------------------

	if [ "${ACCESSION}" = "Accession" ] ; then
	    continue
	fi
	if [ -e "${RAW}/${ACCESSION}.faa" -a -z "$FORCE_REANNOTATE" ] ; then
	    continue
	fi

	SAFE_STRAIN="$(echo "$STRAIN" | sed -r -e 's/[^A-Za-z0-9_-]+//g')"
	SAFE_ACCESSION="$(echo "$ACCESSION" | sed -r -e 's/[^A-Za-z0-9_.-]+//g')"

	# ------------------------------

	ORG_FIELDS=($ORGANISM)
	if [ "${#ORG_FIELDS[@]}" -lt 2 ] ; then
	    echo 1>&2 Error: organism name must contain at least two words: "${ORG_FIELDS[@]}"
	    exit 1
	fi

	GENUS="${ORG_FIELDS[0]}"
	unset ORG_FIELDS[0]
	if [ ${GENUS} = "Candidatus" -o ${GENUS} = "uncultured" ] ; then
	    GENUS+=" ${ORG_FIELDS[1]}"
	    unset ORG_FIELDS[1]
	fi
	SPECIES="${ORG_FIELDS[@]}"

	# ------------------------------
	
	if [ "$REANNOTATE_WITH" = prokka ] ; then

	    OUTPUT=${REANNOTATED}/${ACCESSION}_prokka

	    if [ -e ${OUTPUT}/output.gbk ] ; then
		echo 1>&2 "# Skipping: $ACCESSION ($ORGANISM $STRAIN)"
		continue
	    fi

	    echo 1>&2 "# Running Prokka: $ACCESSION ($ORGANISM $STRAIN)"
	    rm -rf ${OUTPUT}

	    if [ "$FORCE_REANNOTATE" = 2 ] ; then
		PROTEIN_ARGS="--protein ${RAW}/${ACCESSION}.gbk"
		echo "## with \"$PROTEIN_ARGS\""
	    else
		PROTEIN_ARGS=
	    fi

	    prokka ${PROKKA_ARGS} \
		   --outdir ${OUTPUT} \
		   --strain ${SAFE_STRAIN} \
		   ${PROTEIN_ARGS} \
		   ${RAW}/${ACCESSION}.fna

	    # --locustag ${SAFE_ACCESSION}_prokka

	# ------------------------------

	elif [ "$REANNOTATE_WITH" = bakta ] ; then

	    OUTPUT=${REANNOTATED}/${ACCESSION}_bakta

	    if [ -e ${OUTPUT}/${SAFE_STRAIN}.gbk ] ; then
		echo 1>&2 "# Skipping: $ACCESSION ($ORGANISM $STRAIN)"
		continue
	    fi

	    echo 1>&2 "# Running Bakta: $ACCESSION ($ORGANISM $STRAIN)"
	    rm -rf ${OUTPUT}

	    if [ "$FORCE_REANNOTATE" = 2 ] ; then
		PROTEIN_ARGS="--proteins ${RAW}/${ACCESSION}.gbk"
		echo "## with \"$PROTEIN_ARGS\""
	    else
		PROTEIN_ARGS=
	    fi

	    COMPLETE_ARG=
	    if [ "${LEVEL}" = "Complete Genome" ] ; then
		COMPLETE_ARG="--complete"
	    fi

	    # ------------------------------
	    
	    (
		set -x

		bakta \
		    --db ${BAKTA_DB} \
		    --keep-contig-headers \
		    --threads ${THREADS} \
		    --tmp-dir ${DATA}/tmp \
		    --output ${OUTPUT} \
		    --prefix output \
		    --genus "${GENUS}" \
		    --species "${SPECIES}" \
		    --strain "${STRAIN}" \
		    ${COMPLETE_ARG} \
		    ${RAW}/${ACCESSION}.fna
	    )

	# ------------------------------

	else
	    echo 1>&2 "Not implemented: $REANNOTATE_WITH"
	    exit 1
	fi

    done
)

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

