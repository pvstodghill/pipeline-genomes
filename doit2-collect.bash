#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

rm -rf ${RAW}
mkdir -p ${RAW}

echo Accession$'\t'Source$'\t'Organism$'\t'Strain$'\t'Level$'\t'Date \
     > ${RAW}/_metadata_.tmp.tsv

# ------------------------------------------------------------------------
# Collect the NCBI genomes
# ------------------------------------------------------------------------

if [ -e ${DOWNLOADS}/ncbi_00.zip ] ; then

    echo 1>&2 "# Unzip the NCBI genomes"
    NCBI_TMP=${RAW}/ncbi_tmp
    mkdir ${NCBI_TMP}
    for z in ${DOWNLOADS}/ncbi_*.zip ; do
	ncbi_xx=$(basename $z .zip)
	unzip -q -d ${NCBI_TMP}/${ncbi_xx} $z
    done

    echo 1>&2 "# Collect the NCBI genomes"
    for d in ${NCBI_TMP}/ncbi_*/ncbi_dataset/data/GC* ; do
	accession=$(basename $d)
	(
	    shopt -s nullglob
	    n=$(ls /dev/null ${NCBI_TMP}/ncbi_*/ncbi_dataset/data/$accession/*.fna | wc -l)
	    if [ "$n" == 1 ] ; then
		echo 1>&2 "Cannot determine genome for $accession"
		exit 1
	    fi
	)
	ls ${NCBI_TMP}/ncbi_*/ncbi_dataset/data/$accession/*.fna \
	    | grep -v '\(cds_from_genomic\|rna\)\.fna' \
	    | xargs cat > ${RAW}/$accession.fna
	if [ -e ${NCBI_TMP}/ncbi_*/ncbi_dataset/data/$accession/protein.faa ] ; then
	    cp ${NCBI_TMP}/ncbi_*/ncbi_dataset/data/$accession/protein.faa ${RAW}/$accession.faa
	fi
    done

    echo 1>&2 "# Deleting unzipped NCBI genomes"
    rm -rf ${NCBI_TMP}

    cat ${DOWNLOADS}/ncbi_*.jsonl \
	| ${PIPELINE}/scripts/meta-data-from-assembly_data_report \
	>> ${RAW}/_metadata_.tmp.tsv

fi

# ------------------------------------------------------------------------
# Collect the local genomes
# ------------------------------------------------------------------------

if [ "$MORE_GENOMES" ] ; then
    dups=
    echo 1>&2 "# Collect the local genomes"
    for f in $MORE_GENOMES/*.f?a ; do
	case "$f" in
	    *.fna|*.faa) : ok ;;
	    *)
		echo 1>&2 "Unknown local genome type: $f"
		exit 1
	esac
	ff=$(basename $f)
	if [ -e ${RAW}/$ff ] ; then
	    echo 1>&2 "Already exists: ${RAW}/$ff"
	    dups=1
	else
	    cp $f ${RAW}/$ff
	fi
    done
    if [ "$dups" ] ; then
	exit 1
    fi

    if [ 1 = "$(head -n1 ${MORE_GENOMES}/_metadata_.tsv | grep '^Access' | wc -l)" ] ; then
    	tail -n+2 ${MORE_GENOMES}/_metadata_.tsv \
	     >> ${RAW}/_metadata_.tmp.tsv
    else
	cat ${MORE_GENOMES}/_metadata_.tsv \
	    >> ${RAW}/_metadata_.tmp.tsv
    fi

fi

# ------------------------------------------------------------------------
# Rename everthing according to metadata
# ------------------------------------------------------------------------

cat ${RAW}/_metadata_.tmp.tsv \
    | ${PIPELINE}/scripts/make-filenames-from-metadata \
		 -a ${COLLECT_EXCLUDE} ${COLLECT_ABBREVS} \
		 > ${RAW}/_metadata_.tsv
rm -f ${RAW}/_metadata_.tmp.tsv

cd ${RAW}
cat _metadata_.tsv | \
    (
	while IFS=$'\t' read ACCESSION FNAME IGNORED ; do
	    if [ "${ACCESSION}" = Accession ] ; then
		continue
	    fi
	    if [ "${ACCESSION}" = "${FNAME}" ] ; then
		echo 1>&2 "## ${ACCESSION} unchanged"
	    else
		echo 1>&2 "## ${ACCESSION} -> ${FNAME}"
		for ext in fna faa ; do
		    if [ -e ${ACCESSION}.${ext} ] ; then
			if [ -e ${FNAME}.${ext} ] ; then
			    echo 1>&2 "${FNAME}.fna already exists."
			fi
			mv "${ACCESSION}.${ext}" "${FNAME}.${ext}"
		    fi
		done
	    fi
	done
    )

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

