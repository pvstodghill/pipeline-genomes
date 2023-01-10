# directory into which the results are written.
#DATA=.
#DATA=data # default

# Allow steps to restart after an error (is fixed).
PIPELINE_RESTART=1

# ------------------------------------------------------------------------

# NCBI_REFSEQ_TAXONS=574096 # P.allii
# NCBI_REFSEQ_REFERENCE_ONLY=1
# NCBI_GENBANK_TAXONS=
# NCBI_GENBANK_REFERENCE_ONLY=1
# NCBI_ACCESSIONS=GCF_017474015.1 # P.ananatis OC5a

# # Directory containing genomes to add
# MORE_GENOMES=local

# ------------------------------------------------------------------------

GENOME_NAME_ARGS=
# GENOME_NAME_ARGS+=" -s" # Do not include genus/species in genome names
# GENOME_NAME_ARGS+=" -a" # Remove non-alphabetic chars from genome names
# GENOME_NAME_ARGS+=" -u" # Make genome names uppercase
# GENOME_NAME_ARGS+=" -d" # Throw error if dup names detected
GENOME_NAME_ARGS+=" -D" # Drop older redundent assemblies heuristically

# EXCLUDE_ACCESSIONS=
# EXCLUDE_ACCESSIONS+=" GCF_002095545.1" # LMG_24248~

# ------------------------------------------------------------------------

# Uncomment to reannotate with Prokka. Otherwise, use existing
# annotations.
FORCE_REANNOTATE=1
# # v-- You probably don't want to uncomment these. They have no effect.
#PROKKA_GRAM=neg
#PROKKA_GENUS=Pantoea
#PROKKA_SPECIES=allii

# ------------------------------------------------------------------------

BUSCO_LINEAGE= # use --auto-lineage-prok
#BUSCO_LINEAGE=enterobacterales_odb10

# ------------------------------------------------------------------------

# Analyses for pyANI to perform
PYANI_METHODS=
# PYANI_METHODS+=" ANIb"
PYANI_METHODS+=" ANIm"
# PYANI_METHODS+=" ANIblastall"
PYANI_METHODS+=" TETRA"

# ------------------------------------------------------------------------

# # Uncomment to get packages from HOWTO
# PACKAGES_FROM=howto

# uncomment to use conda
PACKAGES_FROM=conda
CONDA_ENV=pipeline-genomes

#THREADS=$(nproc --all)

# ------------------------------------------------------------------------
