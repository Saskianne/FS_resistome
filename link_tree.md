# Link tree

References/Literature:



Bioinformatic tools:
- Preprocessing
    - sra-tools (bioconda::sra-tools, v3.2.0)
    - parallel fastq dump (bioconda::parallel-fastq-dump, v0.6.7)
    - parallel (conda-forge::parallel, v20241222)
- Assembly
    - metaSPAdes (bioconda::spades, v4.0.0)
    - Trimmomatric (bioconda::trimmomatic, v0.39)
    - bbmap (bioconda::bbmap, v39.15)
- Resistome analysis
    - AntiSMASH (bioconda::antismash, v7.1.0)
        - conda-forge::scikit-learn, v1.6.1
        - conda-forge::icu , v73.2
            - must be >=64.2,<65.0a0
        - bioconda::meme, v5.8.5
        - python=3.10
    - DeepARG (bioconda::deeparg, v1.0.4)
    


General understanding:
- Metagenome assembly with metaSPAdes: https://carpentries-lab.github.io/metagenomics-analysis/04-assembly/index.html
- conda: https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-pkgs.html
- 
