#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------
# Generating stats...
# ------------------------------------------------------------------------

echo 1>&2 '# Generating stats...'

rm -rf ${STATS}
mkdir -p ${STATS}

echo Name$'\t'Seqs$'\t'Bases$'\t'Median$'\t'Mean$'\t'N50$'\t'L50$'\t'Min$'\t'Max \
     > ${STATS}/stats.tsv


cat ${RAW}/_metadata_.tsv | (
    while IFS=$'\t' read NAME IGNORED ; do
	if [ "${NAME}" = "Name" ] ; then
	    continue
	fi
	
	cat ${GENOMES}/${NAME}.fna \
	    | ${PIPELINE}/scripts/fastx2stats -t ${NAME} -a -s -d$'\t' \
			 >> ${STATS}/stats.tsv
    done
)

# ------------------------------------------------------------------------
# Generating metadata file...
# ------------------------------------------------------------------------

echo 1>&2 '# Generating metadata file...'

${PIPELINE}/scripts/my-join \
	   ${RAW}/_metadata_.tsv \
	   ${STATS}/stats.tsv \
	   ${BUSCO}/__report__.txt \
	   > ${DATA}/metadata.tmp.tsv

(
    grep '^Name' ${DATA}/metadata.tmp.tsv
    grep -v '^Name' ${DATA}/metadata.tmp.tsv
) > ${DATA}/metadata.tsv
rm -f ${DATA}/metadata.tmp.tsv


# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

