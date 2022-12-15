#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

rm -rf ${GENOMES}
mkdir -p ${GENOMES}

# ------------------------------------------------------------------------
# Collect the NCBI genomes
# ------------------------------------------------------------------------

if [ -e ${DOWNLOADS}/ncbi_00.zip ] ; then

    echo 1>&2 "# Unzip the NCBI genomes"
    NCBI_TMP=${GENOMES}/ncbi_tmp
    mkdir ${NCBI_TMP}
    for z in ${DOWNLOADS}/ncbi_*.zip ; do
	ncbi_xx=$(basename $z .zip)
	unzip -q -d ${NCBI_TMP}/${ncbi_xx} $z
    done

    echo 1>&2 "# Collect the NCBI genomes"
    cat ${NCBI_TMP}/ncbi_*/ncbi_dataset/data/assembly_data_report.jsonl \
	| ${PIPELINE}/scripts/make-filenames-from-assembly_data_report ${GENOME_NAME_ARGS}  ${EXCLUDE_ACCESSIONS} \
	| (
	IFS=$'\t'
	while read -a accession_name ; do
	    accession=${accession_name[0]}
	    name=${accession_name[1]}
	    echo 1>&2 "## $accession -> $name"
	    if [ -e ${GENOMES}/$name.fna ] ; then
		echo 1>&2 "Already exists: ${GENOMES}/$name.fna"
		exit 1
	    fi
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
		| xargs cat > ${GENOMES}/$name.fna
	    if [ -e ${GENOMES}/$name.faa ] ; then
		echo 1>&2 "Already exists: ${GENOMES}/$name.faa"
		exit 1
	    fi
	    cp ${NCBI_TMP}/ncbi_*/ncbi_dataset/data/$accession/protein.faa ${GENOMES}/$name.faa
	done
    )

    echo 1>&2 "# Deleting unzipped NCBI genomes"
    rm -rf ${NCBI_TMP}
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
	if [ -e ${GENOMES}/$ff ] ; then
	    echo 1>&2 "Already exists: ${GENOMES}/$ff"
	    dups=1
	else
	    cp $f ${GENOMES}/$ff
	fi
    done
    if [ "$dups" ] ; then
	exit 1
    fi
fi

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

