#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

rm -rf ${RAW}
mkdir -p ${RAW}

${PIPELINE}/scripts/fix-genomes-metadata -H \
	   > ${RAW}/_metadata_.tsv

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

    echo 1>&2 "# Rehydrate the NCBI genomes"
    for z in ${DOWNLOADS}/ncbi_*.zip ; do
	ncbi_xx=$(basename $z .zip)
	datasets rehydrate --directory ${NCBI_TMP}/${ncbi_xx}
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
	if [ -e ${NCBI_TMP}/ncbi_*/ncbi_dataset/data/$accession/genomic.gff ] ; then
	    cp ${NCBI_TMP}/ncbi_*/ncbi_dataset/data/$accession/genomic.gff ${RAW}/$accession.gff
	fi
	if [ -e ${NCBI_TMP}/ncbi_*/ncbi_dataset/data/$accession/protein.faa ] ; then
	    cp ${NCBI_TMP}/ncbi_*/ncbi_dataset/data/$accession/protein.faa ${RAW}/$accession.faa
	fi
    done

    echo 1>&2 "# Deleting unzipped NCBI genomes"
    rm -rf ${NCBI_TMP}

    cat ${DOWNLOADS}/ncbi_*.jsonl \
	| ${PIPELINE}/scripts/datasets-json2tsv \
	| ${PIPELINE}/scripts/fix-genomes-metadata -n \
		     >> ${RAW}/_metadata_.tsv

fi

# ------------------------------------------------------------------------
# Collect the local genomes
# ------------------------------------------------------------------------

if [ "$MORE_GENOMES" ] ; then
    dups=
    echo 1>&2 "# Collect the local genomes"
    (
	shopt -s nullglob
	for f in $MORE_GENOMES/*.* ; do
	    case "$f" in
		*.faa) : ok ;;
		*.fna) : ok ;;
		*.gbk) : ok ;;
		*.gff) : ok ;;
		*.gtf) : ok ;;
		*)
		    continue
	    esac
	    ff=$(basename $f)
	    if [ -e ${RAW}/$ff ] ; then
		echo 1>&2 "Already exists: ${RAW}/$ff"
		dups=1
	    else
		cp $f ${RAW}/$ff
	    fi
	done
    )
    if [ "$dups" ] ; then
	exit 1
    fi

    cat ${MORE_GENOMES}/_metadata_.tsv \
    	| ${PIPELINE}/scripts/fix-genomes-metadata -n \
		     >> ${RAW}/_metadata_.tsv
fi

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

