# Link tree

References/Literature:
- Porifera data base: https://www.marinespecies.org/porifera/


Bioinformatic tools:
- Preprocessing
    - sra-tools (bioconda::sra-tools, v3.2.0)
    - parallel fastq dump (bioconda::parallel-fastq-dump, v0.6.7)
    - parallel (conda-forge::parallel, v20241222)
- Assembly
    - fastqc(v0.12.1)
        - https://hbctraining.github.io/Intro-to-rnaseq-hpc-salmon-flipped/lessons/05_qc_running_fastqc_interactively.html
        - examples: https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
    - multiqc(v1.27.1)
        - https://docs.seqera.io/multiqc/getting_started/running_multiqc
    - metaSPAdes (bioconda::spades, v4.0.0)
    - Trimmomatric (bioconda::trimmomatic, v0.39)
    - bbmap (bioconda::bbmap, v39.15)
    - wtdbg2(v2.5)
        - https://github.com/ruanjue/wtdbg2
    - Unicycler (v0.5.1)
        - https://github.com/rrwick/Unicycler?tab=readme-ov-file#method-long-read-only-assembly
    - (meta)Flye (v2.9.5)
        - https://github.com/mikolmogorov/Flye/blob/flye/docs/USAGE.md
    - Canu (v2.3)
        - https://github.com/marbl/canu
    - (meta)Quast (v5.3.0)
        - https://quast.sourceforge.net/docs/manual.html#sec2.4
        - https://github.com/ziyewang/MetaAssemblyEval
- Resistome analysis
    - AntiSMASH (bioconda::antismash, v7.1.0)
        - installation manual: https://docs.antismash.secondarymetabolites.org/install/
        - conda-forge/label/python_rc::_python_rc
        - conda-forge::libsass=0.22.0
        - python=3.10
    - DeepARG (bioconda::deeparg, v1.0.4)
    


General understanding:
- Metagenome assembly with metaSPAdes: https://carpentries-lab.github.io/metagenomics-analysis/04-assembly/index.html
- conda: https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-pkgs.html
- general bash & shell: https://www.gnu.org/software/bash/manual/bash.html#Installing-Bash


