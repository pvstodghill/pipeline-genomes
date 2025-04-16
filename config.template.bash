# directory into which the results are written.
#DATA=.
#DATA=data # default

# Allow steps to restart after an error (is fixed).
#PIPELINE_RESTART=1

# ------------------------------------------------------------------------

# NCBI_REFSEQ_TAXONS=574096 # P.allii
# NCBI_REFSEQ_REFERENCE_ONLY=1
# NCBI_REFSEQ_COMPLETE_ONLY=1
# NCBI_GENBANK_TAXONS=
# NCBI_GENBANK_REFERENCE_ONLY=1
# NCBI_GENBANK_COMPLETE_ONLY=1
# NCBI_ACCESSIONS=GCF_017474015.1 # P.ananatis OC5a

# # Directory containing genomes to add
# MORE_GENOMES=local

# ------------------------------------------------------------------------

# Uncomment to reannotate with Prokka or BAKTA. Otherwise, use existing
# annotations.
#FORCE_REANNOTATE=1 # Perform de novo protein id
FORCE_REANNOTATE=2 # use RefSeq or Genbank .gbk as trusted protein DB

REANNOTATE_WITH=prokka
#REANNOTATE_WITH=bakta

# # v-- You probably don't want to uncomment these. They have no effect.
#PROKKA_GRAM=neg
#PROKKA_GENUS=Pantoea
#PROKKA_SPECIES=allii

#BAKTA_DB=/path/to/bakta/db_dir

# ------------------------------------------------------------------------

#BUSCO_LINEAGE= # use --auto-lineage-prok
BUSCO_LINEAGE=FIXME
#BUSCO_DOWNLOADS=/tmp/busco_downloads

# ------------------------------------------------------------------------

# Uncomment to get packages from HOWTO
PACKAGES_FROM=howto

# # Uncomment to use conda
# PACKAGES_FROM=conda
# CONDA_ENV=pipeline-genomes

# # Uncomment to find packages on $PATH
# PACKAGES_FROM=native

#THREADS=$(nproc --all)

# ------------------------------------------------------------------------
