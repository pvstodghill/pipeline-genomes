#! /bin/bash

. doit-preamble.bash

rm -rf ${GENOMES}
mkdir -p ${GENOMES}

# ------------------------------------------------------------------------
# Collect the NCBI genomes
# ------------------------------------------------------------------------

if [ -e ${DOWNLOADS}/ncbi_00 ] ; then
    echo 1>&2 "# Collect the NCBI genomes"

    cat ${DOWNLOADS}/ncbi_*/ncbi_dataset/data/assembly_data_report.jsonl \
	| ./scripts/make-filenames-from-assembly_data_report -s ${EXCLUDE_ACCESSIONS} \
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
	    cat ${DOWNLOADS}/ncbi_*/ncbi_dataset/data/$accession/*genomic.fna > ${GENOMES}/$name.fna
	    if [ -e ${GENOMES}/$name.faa ] ; then
		echo 1>&2 "Already exists: ${GENOMES}/$name.faa"
		exit 1
	    fi
	    cp ${DOWNLOADS}/ncbi_*/ncbi_dataset/data/$accession/protein.faa ${GENOMES}/$name.faa
	done
    )
fi

# ------------------------------------------------------------------------
# Collect the local genomes
# ------------------------------------------------------------------------

if [ "$MORE_GENOMES" ] ; then
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
	    exit 1
	fi
	cp $f ${GENOMES}/$ff
    done
fi

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

