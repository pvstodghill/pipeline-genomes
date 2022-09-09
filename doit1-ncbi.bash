#! /bin/bash

. doit-preamble.bash

rm -rf ${DOWNLOADS}
mkdir -p ${DOWNLOADS}

_I=0
_TAG=$(printf "%02d" $_I)

# ------------------------------------------------------------------------
# Download by taxon (refseq)
# ------------------------------------------------------------------------

for TAXID in ${NCBI_REFSEQ_TAXONS} ; do

    echo 1>&2 "# Download (refseq) taxon $TAXID"
    datasets download genome \
	     --no-progressbar \
	     --assembly-source refseq \
	     --exclude-genomic-cds \
	     --exclude-gff3 \
	     --exclude-rna \
	     --filename ${DOWNLOADS}/ncbi_${_TAG}.zip \
	     taxon ${TAXID}

    unzip -q -d ${DOWNLOADS}/ncbi_${_TAG} ${DOWNLOADS}/ncbi_${_TAG}.zip

    _I=$[$_I + 1]
    _TAG=$(printf "%02d" $_I)

done

# ------------------------------------------------------------------------
# Download by taxon (genbank)
# ------------------------------------------------------------------------

for TAXID in ${NCBI_GENBANK_TAXONS} ; do

    echo 1>&2 "# Download (genbank) taxon $TAXID"
    datasets download genome \
	     --no-progressbar \
	     --assembly-source genbank \
	     --exclude-genomic-cds \
	     --exclude-gff3 \
	     --exclude-rna \
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
