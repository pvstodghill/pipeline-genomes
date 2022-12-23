#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------
# Collect genome files
# ------------------------------------------------------------------------

echo 1>&2 "# Collect genome files"

rm -rf ${GENOMES}
mkdir -p ${GENOMES}

for FNA in ${RAW}/*.fna ; do
    ACCESSION=$(basename $FNA .fna)
    for EXT in fna faa gff+fna ; do
	if [ -e ${PROKKA}/${ACCESSION}.${EXT} ] ; then
	    cp ${PROKKA}/${ACCESSION}.${EXT} ${GENOMES}/${ACCESSION}.${EXT}
	elif [ -e ${RAW}/${ACCESSION}.${EXT} ] ; then
	    cp ${RAW}/${ACCESSION}.${EXT} ${GENOMES}/${ACCESSION}.${EXT}
	else
	    echo 1>&2 "Cannot find: ${ACCESSION}.${EXT}"
	    exit 1
	fi
    done
done


# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

