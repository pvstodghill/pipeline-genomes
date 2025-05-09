#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------
# Generating stats...
# ------------------------------------------------------------------------

echo 1>&2 '# Generating stats...'

rm -rf ${STATS}
mkdir -p ${STATS}

echo Accession$'\t'Seqs$'\t'Bases$'\t'Median$'\t'Mean$'\t'N50$'\t'L50$'\t'Min$'\t'Max \
     > ${STATS}/stats.tsv


cat ${RAW}/_metadata_.tsv | (
    while IFS=$'\t' read ACCESSION IGNORED ; do
	if [ "${ACCESSION}" = "Accession" ] ; then
	    continue
	fi
	
	cat ${GENOMES}/${ACCESSION}.fna \
	    | ${PIPELINE}/scripts/fastx2stats -t ${ACCESSION} -a -s -d$'\t' \
			 >> ${STATS}/stats.tsv
    done
)

# ------------------------------------------------------------------------
# Generating metadata file...
# ------------------------------------------------------------------------

echo 1>&2 '# Generating metadata file...'

BUSCO_REPORT=${BUSCO}/__report__.txt
if [ "$SKIP_BUSCO" ] ; then
    BUSCO_REPORT=
fi

${PIPELINE}/scripts/my-join \
	   ${RAW}/_metadata_.tsv \
	   ${STATS}/stats.tsv \
	   ${BUSCO_REPORT} \
	   > ${DATA}/metadata.tmp.tsv

(
    grep '^Accession' ${DATA}/metadata.tmp.tsv
    grep -v '^Accession' ${DATA}/metadata.tmp.tsv
) > ${DATA}/metadata.tsv
rm -f ${DATA}/metadata.tmp.tsv

# ------------------------------------------------------------------------
# Generating metadata file...
# ------------------------------------------------------------------------

echo 1>&2 '# print version numbers...'

(
    set -x
    bakta --version
    busco --version
    datasets --version
    prokka --version
)


# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

