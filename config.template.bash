# directory into which the results are written.
#DATA=.
#DATA=data # default

# ------------------------------------------------------------------------

# NCBI_REFSEQ_TAXONS=574096 # P.allii
# NCBI_GENBANK_TAXONS=
# NCBI_ACCESSIONS=GCF_017474015.1 # P.ananatis OC5a

# ------------------------------------------------------------------------

# EXCLUDE_ACCESSIONS=
# EXCLUDE_ACCESSIONS+=" GCF_002095545.1" # LMG_24248~

MORE_GENOMES=inputs

# ------------------------------------------------------------------------

#FORCE_REANNOTATE=1
PROKKA_GRAM=neg
PROKKA_GENUS=Pantoea
#PROKKA_SPECIES=allii

# ------------------------------------------------------------------------

#FIXME: specify busco lineage (--auto-lineage-prok)

#BUSCO_C_CUTOFF=99.8 # crazy strict
BUSCO_S_CUTOFF=95.0 # pretty loose

# ------------------------------------------------------------------------

# # Uncomment to get packages from HOWTO
# PACKAGES_FROM=howto

# uncomment to use conda
PACKAGES_FROM=conda
CONDA_ENV=pipeline-genomes

#THREADS=$(nproc --all)

# ------------------------------------------------------------------------
