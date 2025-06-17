#!/bin/bash

# Input files
ANNOT="/gxfs_work/geomar/smomw681/NANOPORE_DATA/ARG_BLAST_JUTTA/eggNOG_ANNOTATION/MM_v2_3kwd0.emapper.annotations.tsv"
BLAST="/gxfs_work/geomar/smomw681/NANOPORE_DATA/ARG_BLAST_JUTTA/BLASTX_JUTTA_STRAIN/BLASTX_J_ARG1_WGS_PCR_HIT_with_annot.txt"
OUT="/gxfs_work/geomar/smomw681/NANOPORE_DATA/ARG_BLAST_JUTTA/BLASTx_X_eggNOG.tsv"

cat OFSP="\t" "Query" "Locustag" "eggNOG_Description" "eggNOG_Function" "eggNOG_PFAM" > "$OUT"

# AWK script
awk -F'\t' '
    # Step 1: Read annotation file
    FNR==NR && !/^#/ && NF>=21 {
        annots[$1] = $8 "\t" $9 "\t" $21
        next
    }

    # Step 2: Process BLASTX file
    /^#/ {
        print; next  # Keep comment lines unchanged
    }

    {
        query = $1
        subject = $2

        if (subject in annots) {
            print query, subject, annots[subject]
        } else {
            print query, subject, "NA", "NA", "NA"
        }
    }
' OFS='\t' "$ANNOT" "$BLAST" >> "$OUT"
