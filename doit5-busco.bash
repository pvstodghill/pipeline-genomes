#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------
# Running BUSCO...
# ------------------------------------------------------------------------

rm -rf ${BUSCO}
mkdir -p ${BUSCO}

if [ "$BUSCO_LINEAGE" ] ; then
    LINEAGE_ARG="--lineage_dataset $BUSCO_LINEAGE"
else
    LINEAGE_ARG="--auto-lineage-prok"
fi

for FAA in ${PROTEOMES}/*.faa ; do
    STRAIN=$(basename $FAA .faa)
    echo 1>&2 "# Running BUSCO: $STRAIN"

    busco \
		     -q \
		     -i ${FAA} \
		     -o ${BUSCO}/output_${STRAIN} \
		     -m proteins \
		     ${LINEAGE_ARG} \
		     -c ${THREADS} \
		     --download_path ${BUSCO}/downloads
    done

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

