#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------
# Collect genome files
# ------------------------------------------------------------------------

echo 1>&2 "# Collect genome files"

rm -rf ${GENOMES}
mkdir -p ${GENOMES}

cat ${RAW}/_metadata_.tsv | (
    while IFS=$'\t' read ACCESSION IGNORED ; do
	if [ "${ACCESSION}" = "Accession" ] ; then
	    continue
	fi
	for EXT in fna faa gff ; do
	    if [ -e ${PROKKA}/${ACCESSION}_prokka/output.${EXT} ] ; then
		cp ${PROKKA}/${ACCESSION}_prokka/output.${EXT} ${GENOMES}/${ACCESSION}.${EXT}
	    elif [ -e ${RAW}/${ACCESSION}.${EXT} ] ; then
		cp ${RAW}/${ACCESSION}.${EXT} ${GENOMES}/${ACCESSION}.${EXT}
	    else
		echo 1>&2 "Cannot find: ${ACCESSION}.${EXT}"
		exit 1
	    fi
	done
    done
)


# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

