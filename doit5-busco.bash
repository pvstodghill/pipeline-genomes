#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------
# Running BUSCO...
# ------------------------------------------------------------------------

rm -rf ${BUSCO}
mkdir -p ${BUSCO}

for FAA in ${PROTEOMES}/*.faa ; do
    STRAIN=$(basename $FAA .faa)
    echo 1>&2 "# Running BUSCO: $STRAIN"

    busco \
		     -q \
		     -i ${FAA} \
		     -o ${BUSCO}/output_${STRAIN} \
		     -m proteins \
		     --auto-lineage-prok \
		     -c ${THREADS} \
		     --download_path ${BUSCO}/downloads
    done

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

