#! /bin/bash

. doit-preamble.bash

rm -rf ${FINAL}
mkdir -p ${FINAL}

# ------------------------------------------------------------------------
# Generate BUSCO summary
# ------------------------------------------------------------------------

echo 1>&2 "# Generate BUSCO summary"
(
    cd ${BUSCO}

    
    echo -e "Name\tdb\tC\tS\tD\tF\tM\tn"
    egrep '^'$'\t''C:' /dev/null output_*/short_summary.specific.*.txt \
	| sed -r \
	      -e 's/^output_//' \
	      -e 's|/short_summary\.specific\.(.+)_odb10.output_.+\.txt:|\t\1|' \
	      -e 's/[ \t]+$//' \
	      -e 's/C:([0-9.%]+)\[S:([0-9.%]+),D:([0-9.%]+)\],F:([0-9.%]+),M:([0-9.%]+),n:([0-9.%]+)/\1\t\2\t\3\t\4\t\5\t\6/'
) > ${FINAL}/__report__.txt

echo "## Unfiltered strain(s):" $(tail -n+2 ${FINAL}/__report__.txt | wc -l)

# ------------------------------------------------------------------------
# Apply cutoffs
# ------------------------------------------------------------------------

echo 1>&2 '# Apply cutoffs'

_args_=
if [ "$BUSCO_C_CUTOFF" ] ; then
    _args_+=" -C $BUSCO_C_CUTOFF"
fi
if [ "$BUSCO_S_CUTOFF" ] ; then
    _args_+=" -S $BUSCO_S_CUTOFF"
fi

cat ${FINAL}/__report__.txt \
    | ./scripts/filter-busco-report.pl $_args_ \
    | tail -n+2 \
    | cut -f1 \
	  > ${FINAL}/__filtered_strains__.txt

echo "## Unfiltered strain(s):" $(cat ${FINAL}/__filtered_strains__.txt | wc -l )


# ------------------------------------------------------------------------
# Collecting final genomes
# ------------------------------------------------------------------------

echo 1>&2 '# Collecting final genomes'

cat ${FINAL}/__filtered_strains__.txt \
    | (
    while read STRAIN ; do
	for EXT in fna faa ; do
	    if [ -e ${PROKKA}/${STRAIN}.${EXT} ] ; then
		cp ${PROKKA}/${STRAIN}.${EXT} ${FINAL}/${STRAIN}.${EXT}
	    elif [ -e ${GENOMES}/${STRAIN}.${EXT} ] ; then
		cp ${GENOMES}/${STRAIN}.${EXT} ${FINAL}/${STRAIN}.${EXT}
	    else
		echo 1>&2 "Cannot find: ${STRAIN}.${EXT}"
		exit 1
	    fi
	done
    done
)

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."

