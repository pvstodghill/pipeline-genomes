#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------
# Collect genome files
# ------------------------------------------------------------------------

echo 1>&2 "# Collect genome files"

rm -rf ${GENOMES}
mkdir -p ${GENOMES}

cat ${RAW}/_metadata_.tsv | (
    while IFS=$'\t' read ACCESSION FNAME SOURCE ORGANISM STRAIN LEVEL DATE ; do
	if [ "${ACCESSION}" = "Accession" ] ; then
	    continue
	fi
	for EXT in fna faa gff ; do
	    if [ -e ${PROKKA}/${FNAME}_prokka/output.${EXT} ] ; then
		cp ${PROKKA}/${FNAME}_prokka/output.${EXT} ${GENOMES}/${FNAME}.${EXT}
	    elif [ -e ${RAW}/${FNAME}.${EXT} ] ; then
		cp ${RAW}/${FNAME}.${EXT} ${GENOMES}/${FNAME}.${EXT}
	    else
		echo 1>&2 "Cannot find: ${FNAME}.${EXT}"
		exit 1
	    fi
	done
    done
)


# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

