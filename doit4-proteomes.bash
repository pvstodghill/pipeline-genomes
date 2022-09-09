#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------
# Collect proteomes
# ------------------------------------------------------------------------

echo 1>&2 "# Collect proteomes"

rm -rf ${PROTEOMES}
mkdir -p ${PROTEOMES}

for FNA in ${GENOMES}/*.fna ; do
    STRAIN=$(basename $FNA .fna)
    if [ -e ${PROKKA}/${STRAIN}.faa ] ; then
	cp ${PROKKA}/${STRAIN}.faa ${PROTEOMES}/${STRAIN}.faa
    elif [ -e ${GENOMES}/${STRAIN}.faa ] ; then
	cp ${GENOMES}/${STRAIN}.faa ${PROTEOMES}/${STRAIN}.faa
    else
	echo 1>&2 "Cannot find: ${STRAIN}.faa"
	exit 1
    fi
done


# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

