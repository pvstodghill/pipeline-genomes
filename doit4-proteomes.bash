#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------
# Collect proteomes
# ------------------------------------------------------------------------

echo 1>&2 "# Collect proteomes"

rm -rf ${PROTEOMES}
mkdir -p ${PROTEOMES}

for FNA in ${GENOMES}/*.fna ; do
    ACCESSION=$(basename $FNA .fna)
    if [ -e ${PROKKA}/${ACCESSION}.faa ] ; then
	cp ${PROKKA}/${ACCESSION}.faa ${PROTEOMES}/${ACCESSION}.faa
    elif [ -e ${GENOMES}/${ACCESSION}.faa ] ; then
	cp ${GENOMES}/${ACCESSION}.faa ${PROTEOMES}/${ACCESSION}.faa
    else
	echo 1>&2 "Cannot find: ${ACCESSION}.faa"
	exit 1
    fi
done


# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

