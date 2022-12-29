#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------
# Collect genome files
# ------------------------------------------------------------------------

echo 1>&2 "# Collect genome files"

rm -rf ${GENOMES}
mkdir -p ${GENOMES}

cat ${RAW}/_metadata_.tsv | (
    while IFS=$'\t' read NAME IGNORED ; do
	if [ "${NAME}" = "Name" ] ; then
	    continue
	fi
	for EXT in fna faa gff ; do
	    if [ -e ${PROKKA}/${NAME}_prokka/output.${EXT} ] ; then
		cp ${PROKKA}/${NAME}_prokka/output.${EXT} ${GENOMES}/${NAME}.${EXT}
	    elif [ -e ${RAW}/${NAME}.${EXT} ] ; then
		cp ${RAW}/${NAME}.${EXT} ${GENOMES}/${NAME}.${EXT}
	    else
		echo 1>&2 "Cannot find: ${NAME}.${EXT}"
		exit 1
	    fi
	done
    done
)


# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

