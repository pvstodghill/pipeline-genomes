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
fi

REFSEQ_ARGS="--assembly-source refseq"
if [ "$NCBI_REFSEQ_REFERENCE_ONLY" ] ; then
    REFSEQ_ARGS+=" --reference"
fi

for TAXID in ${NCBI_REFSEQ_TAXONS} ; do

    echo 1>&2 "# Download (refseq) taxon $TAXID"
    datasets download genome \
	     ${COMMON_ARGS} ${REFSEQ_ARGS} \
	     --dehydrated \
	     --filename ${DOWNLOADS}/ncbi_${_TAG}.zip \
	     taxon ${TAXID}

    _I=$[$_I + 1]
    _TAG=$(printf "%02d" $_I)

done

# ------------------------------------------------------------------------
# Download by taxon (genbank)
# ------------------------------------------------------------------------

GENBANK_ARGS="--assembly-source genbank"
if [ "$NCBI_GENBANK_REFERENCE_ONLY" ] ; then
    GENBANK_ARGS+=" --reference"
fi

for TAXID in ${NCBI_GENBANK_TAXONS} ; do

    echo 1>&2 "# Download (genbank) taxon $TAXID"
    datasets download genome \
	     ${COMMON_ARGS} ${GENBANK_ARGS} \
	     --dehydrated \
	     --filename ${DOWNLOADS}/ncbi_${_TAG}.zip \
	     taxon ${TAXID}

    _I=$[$_I + 1]
    _TAG=$(printf "%02d" $_I)

done

# ------------------------------------------------------------------------
# Download by accession
# ------------------------------------------------------------------------

if [ "$NCBI_ACCESSIONS" ] ; then
    echo 1>&2 "# Download accession(s) $NCBI_ACCESSIONS"
    datasets download genome \
	     ${COMMON_ARGS} \
	     --dehydrated \
	     --filename ${DOWNLOADS}/ncbi_${_TAG}.zip \
 	     accession ${NCBI_ACCESSIONS}

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
