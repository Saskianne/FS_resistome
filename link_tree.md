# Link tree

University:
- https://www.biologie.uni-kiel.de/de/studienangebot/ablage-studiumsrelevanter-dateien-modulbeschreibungen-fpos-studienverlaufsplan-etc/modulhandbuch-msc-biologie#page=120

References/Literature:
- Porifera data base: https://www.marinespecies.org/porifera/


Bioinformatic tools:
- Preprocessing
    - sra-tools (bioconda::sra-tools, v3.2.0)
    - parallel fastq dump (bioconda::parallel-fastq-dump, v0.6.7)
    - parallel (conda-forge::parallel, v20241222)

- QCs
    - fastqc(v0.12.1)
        - https://hbctraining.github.io/Intro-to-rnaseq-hpc-salmon-flipped/lessons/05_qc_running_fastqc_interactively.html
        - examples: https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
    - multiqc(v1.27.1)
        - https://docs.seqera.io/multiqc/getting_started/running_multiqc    
    - filtlong (v0.2.1)
        -  https://github.com/rrwick/Filtlong

- Assembly
    - metaSPAdes (bioconda::spades, v4.0.0)
        - https://ablab.github.io/spades/
    
    - Trimmomatric (bioconda::trimmomatic, v0.39)
    - bbmap (bioconda::bbmap, v39.15)

    - wtdbg2(v2.5)
        - https://github.com/ruanjue/wtdbg2
    - Unicycler (v0.5.1)
        - https://github.com/rrwick/Unicycler?tab=readme-ov-file#method-long-read-only-assembly
    - Trycycler (v0.5.5)
        - https://github.com/rrwick/Trycycler/wiki
    - (meta)Flye (v2.9.5)
        - https://github.com/mikolmogorov/Flye/blob/flye/docs/USAGE.md
    - Canu (v2.3)
        - https://github.com/marbl/canu

    - bandage (v0.8.1)
        - https://github.com/rrwick/Bandage/wiki
    - (meta)Quast (v5.3.0)
        - https://quast.sourceforge.net/docs/manual.html#sec2.4
        - https://github.com/ziyewang/MetaAssemblyEval


- Prep and analysis of MAG
    - DeepMicroClass: 
        - deep-learning-based sequence classifier (for metagenomic contigs)        
            - classified into viruses infecting prokaryotic or eukaryotic hosts, eukaryotic or prokaryotic chromosomes, plasmid
        - https://github.com/chengsly/DeepMicroClass

    - Prodigal
        - protein-coding gene prediction for prokaryotic genomes
        - https://github.com/hyattpd/Prodigal

    - gtbdtk
        - https://ecogenomics.github.io/GTDBTk/

- MAG construction and check
    - MetaBat2
        - adaptive binning algorithm for microbial genome reconstruction from metagenome assemblies 
        - https://bitbucket.org/berkeleylab/metabat/src/master/
    - CheckM2 (v1.1.0)
        - check the quality of MAGs, 
        - Criteria min completeness 50% and contamination under 5%
        - https://github.com/chklovski/CheckM2
    - drep:
        - Dereplicate the MAGs before final mapping, identification and other downstream analysis
        - https://drep.readthedocs.io/en/latest/module_descriptions.html
        - https://github.com/MrOlm/drep
    - CoverM
        - https://github.com/wwood/CoverM
    - GTDB-TK:
        - https://ecogenomics.github.io/GTDBTk/index.html

- Resistome analysis
    - AntiSMASH (bioconda::antismash, v7.1.0)
        - installation manual: https://docs.antismash.secondarymetabolites.org/install/
        - conda-forge/label/python_rc::_python_rc
        - conda-forge::libsass=0.22.0
        - python=3.10
    - DeepARG (bioconda::deeparg, v1.0.4)
    - DeepBGC (v0.1.31)
        - https://github.com/Merck/deepbgc
    


General understanding:
- Metagenome assembly with metaSPAdes: https://carpentries-lab.github.io/metagenomics-analysis/04-assembly/index.html
- conda: https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-pkgs.html
- general bash & shell: https://www.gnu.org/software/bash/manual/bash.html#Installing-Bash
- Bacterial genome assembly guide of Ryan Wick guy: https://rrwick.github.io/2020/10/30/guide-to-bacterial-genome-assembly.html
    - I really love his documentation style
- Data Analytics guide for beginner: https://www.earthdatascience.org/courses/intro-to-earth-data-science/file-formats/use-text-files/format-text-with-markdown-jupyter-notebook/
- regex list: https://perldoc.perl.org/perlre#Regular-Expressions
