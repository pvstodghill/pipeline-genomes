#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------
# Running pyani...
# ------------------------------------------------------------------------

echo 1>&2 '# Running pyani...'

rm -rf ${PYANI} ${DATA}/*_percentage_identity.tab ${DATA}/TETRA_correlations.tab
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

for METHOD in ${PYANI_METHODS} ; do
    case ${METHOD} in
	ANI*)
	    cp --archive ${PYANI}/${METHOD}/${METHOD}_percentage_identity.tab ${DATA}
	    ;;
	TETRA)
	    cp --archive ${PYANI}/${METHOD}/${METHOD}_correlations.tab ${DATA}
	    ;;
	*)
	    echo 1>&2 "Unexpected method: $METHOD"
	    exit 1
    esac
done


# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

