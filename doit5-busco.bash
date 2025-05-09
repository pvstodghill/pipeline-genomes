#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

if [ "$SKIP_BUSCO" ] ; then
    echo 1>&2 "# Skipping BUSCO."
    exit
fi

# ------------------------------------------------------------------------
# Running BUSCO...
# ------------------------------------------------------------------------

rm -rf ${BUSCO}
mkdir -p ${BUSCO}

if [ "$BUSCO_LINEAGE" ] ; then
    if [ "$BUSCO_LINEAGE" = FIXME ] ; then
	echo 1>&2 "## !!! BUSCO_LINEAGE is not set correctly !!!"
	exit 1
    fi
    LINEAGE_ARG="--lineage_dataset $BUSCO_LINEAGE"
else
    LINEAGE_ARG="--auto-lineage-prok"
fi

if [ -z "${BUSCO_DOWNLOADS}" ] ; then
    BUSCO_DOWNLOADS=${BUSCO}/downloads
fi

for FAA in ${GENOMES}/*.faa ; do
    ACCESSION=$(basename $FAA .faa)
    echo 1>&2 "# Running BUSCO: $ACCESSION"

    busco \
		     -q \
		     -i ${FAA} \
		     -o ${BUSCO}/output_${ACCESSION} \
		     -m proteins \
		     ${LINEAGE_ARG} \
		     -c ${THREADS} \
		     --download_path ${BUSCO_DOWNLOADS}
    done

# ------------------------------------------------------------------------
# Generate summary
# ------------------------------------------------------------------------

echo 1>&2 "# Generate summary"
(
    cd ${BUSCO}
    
    echo -e "Accession\tdb\tC\tS\tD\tF\tM\tn"
    egrep '^'$'\t''C:' /dev/null output_*/short_summary.specific.*.txt \
	| sed -r \
	      -e 's/^output_//' \
	      -e 's|/short_summary\.specific\.(.+)_odb[0-9]+.output_.+\.txt:|\t\1|' \
	      -e 's/[ \t]+$//' \
	      -e 's/C:([0-9.%]+)\[S:([0-9.%]+),D:([0-9.%]+)\],F:([0-9.%]+),M:([0-9.%]+),n:([0-9.%]+)/\1\t\2\t\3\t\4\t\5\t\6/'
) > ${BUSCO}/__report__.txt

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

