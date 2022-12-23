#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------
# Running pyani...
# ------------------------------------------------------------------------

echo 1>&2 '# Running pyani...'

rm -rf ${PYANI}
mkdir -p ${PYANI}

for METHOD in ${PYANI_METHODS} ; do
    echo "## ${METHOD}"
    average_nucleotide_identity.py \
	  --method ${METHOD} \
	  --verbose \
	  --indir ${GENOMES} \
	  --outdir ${PYANI}/${METHOD} \
	  --graphics \
	  --workers ${THREADS}
done


# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

