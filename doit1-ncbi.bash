#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

rm -rf ${DOWNLOADS}
mkdir -p ${DOWNLOADS}

_I=0
_TAG=$(printf "%02d" $_I)

# ------------------------------------------------------------------------
# Download by taxon (refseq)
# ------------------------------------------------------------------------

COMMON_ARGS=""
COMMON_ARGS+=" --no-progressbar"
COMMON_ARGS+=" --include genome,seq-report"
if [ -z "$FORCE_REANNOTATE" ] ; then
    COMMON_ARGS+=",protein,gff3,gtf,gbff"
elif [ "$FORCE_REANNOTATE" = 2 ] ; then
    COMMON_ARGS+=",gbff"
fi

REFSEQ_ARGS="--assembly-source refseq"
if [ "$NCBI_REFSEQ_REFERENCE_ONLY" ] ; then
    REFSEQ_ARGS+=" --reference"
fi
if [ "$NCBI_REFSEQ_COMPLETE_ONLY" ] ; then
    REFSEQ_ARGS+=" --assembly-level complete"
fi

MORE_ACCESSIONS=${DOWNLOADS}/more.txt

for TAXID in ${NCBI_REFSEQ_TAXONS} ; do

    if [ "${UPDATE_GENOMES}" ] ; then

	echo 1>&2 "# Find missing (refseq) genomes for taxon $TAXID"
	datasets summary genome taxon ${REFSEQ_ARGS} ${TAXID} \
	    | ./pipeline/scripts/datasets-json2tsv  | cut -f1 \
	    | \
	    while read ACCESSION ; do
		if [ "$ACCESSION" = Accession ] ; then
		    : nop
		elif [ ! -e "${UPDATE_GENOMES}/data/genomes/$ACCESSION.fna" ] ; then
		    echo 1>&2 "## Adding $ACCESSION"
		    echo $ACCESSION >> ${MORE_ACCESSIONS}
		fi
	    done

    else

	echo 1>&2 "# Download (refseq) taxon $TAXID"
	datasets download genome \
		 ${COMMON_ARGS} ${REFSEQ_ARGS} \
		 --dehydrated \
		 --filename ${DOWNLOADS}/ncbi_${_TAG}.zip \
		 taxon ${TAXID}

	_I=$[$_I + 1]
	_TAG=$(printf "%02d" $_I)

    fi

done

# ------------------------------------------------------------------------
# Download by taxon (genbank)
# ------------------------------------------------------------------------

GENBANK_ARGS="--assembly-source genbank"
if [ "$NCBI_GENBANK_REFERENCE_ONLY" ] ; then
    GENBANK_ARGS+=" --reference"
fi
if [ "$NCBI_GENBANK_COMPLETE_ONLY" ] ; then
    REFSEQ_ARGS+=" --assembly-level complete"
fi

for TAXID in ${NCBI_GENBANK_TAXONS} ; do

    if [ "${UPDATE_GENOMES}" ] ; then

	echo 1>&2 "# Find missing (genbank) genomes for taxon $TAXID"
	datasets summary genome taxon ${GENBANK_ARGS} ${TAXID} \
	    | ./pipeline/scripts/datasets-json2tsv  | cut -f1 \
	    | (
	    while read ACCESSION ; do
		if [ "$ACCESSION" = Accession ] ; then
		    : nop
		elif [ ! -e "${UPDATE_GENOMES}/data/genomes/$ACCESSION.fna" ] ; then
		    echo 1>&2 "## Adding $ACCESSION"
		    echo $ACCESSION >> ${MORE_ACCESSIONS}
		fi
	    done

	)

    else

	echo 1>&2 "# Download (genbank) taxon $TAXID"
	datasets download genome \
		 ${COMMON_ARGS} ${GENBANK_ARGS} \
		 --dehydrated \
		 --filename ${DOWNLOADS}/ncbi_${_TAG}.zip \
		 taxon ${TAXID}

	_I=$[$_I + 1]
	_TAG=$(printf "%02d" $_I)

    fi

done

# ------------------------------------------------------------------------
# Download by accession
# ------------------------------------------------------------------------

if [ "$NCBI_ACCESSIONS" ] ; then

    if [ "${UPDATE_GENOMES}" ] ; then

	echo 1>&2 "# Find missing accessions"
	for ACCESSION in $NCBI_ACCESSIONS ; do
	    if [ ! -e "${UPDATE_GENOMES}/data/genomes/$ACCESSION.fna" ] ; then
		echo 1>&2 "## Adding $ACCESSION"
		echo $ACCESSION >> ${MORE_ACCESSIONS}
	    fi
	done

    else

	echo 1>&2 "# Download accession(s): $NCBI_ACCESSIONS"
	datasets download genome \
		 ${COMMON_ARGS} \
		 --dehydrated \
		 --filename ${DOWNLOADS}/ncbi_${_TAG}.zip \
 		 accession ${NCBI_ACCESSIONS}

    fi

fi

# ------------------------------------------------------------------------
# Download missing accessions
# ------------------------------------------------------------------------

if [ -e ${MORE_ACCESSIONS} ] ; then

    echo 1>&2 "# Download missing accession(s): $(cat ${MORE_ACCESSIONS})"
    datasets download genome \
	     ${COMMON_ARGS} \
	     --dehydrated \
	     --filename ${DOWNLOADS}/ncbi_${_TAG}.zip \
 	     accession $(cat ${MORE_ACCESSIONS})


fi

# ------------------------------------------------------------------------
# Extract meta-data
# ------------------------------------------------------------------------

if [ -e ${DOWNLOADS}/ncbi_00.zip ] ; then
    echo 1>&2 "# Extracting meta-data"
    for z in ${DOWNLOADS}/ncbi_*.zip ; do
	unzip -p $z ncbi_dataset/data/assembly_data_report.jsonl \
	      > $(dirname $z)/$(basename $z .zip).jsonl
    done
fi

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."
