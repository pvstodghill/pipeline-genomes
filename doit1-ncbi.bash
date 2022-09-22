#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

rm -rf ${DOWNLOADS}
mkdir -p ${DOWNLOADS}

_I=0
_TAG=$(printf "%02d" $_I)

# ------------------------------------------------------------------------
# Download by taxon (refseq)
# ------------------------------------------------------------------------

BOTH_ARGS=""
BOTH_ARGS+=" --no-progressbar"
BOTH_ARGS+=" --exclude-genomic-cds"
BOTH_ARGS+=" --exclude-gff3"
BOTH_ARGS+=" --exclude-rna"

REFSEQ_ARGS="--assembly-source refseq"
if [ "$NCBI_REFSEQ_REFERENCE_ONLY" ] ; then
    REFSEQ_ARGS+=" --reference"
fi

for TAXID in ${NCBI_REFSEQ_TAXONS} ; do

    echo 1>&2 "# Download (refseq) taxon $TAXID"
    datasets download genome \
	     ${BOTH_ARGS} ${REFSEQ_ARGS} \
	     --filename ${DOWNLOADS}/ncbi_${_TAG}.zip \
	     taxon ${TAXID}

    unzip -q -d ${DOWNLOADS}/ncbi_${_TAG} ${DOWNLOADS}/ncbi_${_TAG}.zip

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
	     ${BOTH_ARGS} ${GENBANK_ARGS} \
	     --filename ${DOWNLOADS}/ncbi_${_TAG}.zip \
	     taxon ${TAXID}

    unzip -q -d ${DOWNLOADS}/ncbi_${_TAG} ${DOWNLOADS}/ncbi_${_TAG}.zip

    _I=$[$_I + 1]
    _TAG=$(printf "%02d" $_I)

done

# ------------------------------------------------------------------------
# Download by accession
# ------------------------------------------------------------------------

if [ "$NCBI_ACCESSIONS" ] ; then
    echo 1>&2 "# Download accession(s) $NCBI_ACCESSIONS"
    datasets download genome \
 	     --no-progressbar \
 	     --exclude-genomic-cds \
 	     --exclude-gff3 \
 	     --exclude-rna \
 	     --filename ${DOWNLOADS}/ncbi_${_TAG}.zip \
 	     accession ${NCBI_ACCESSIONS}

    unzip -q -d ${DOWNLOADS}/ncbi_${_TAG} ${DOWNLOADS}/ncbi_${_TAG}.zip
fi

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."
