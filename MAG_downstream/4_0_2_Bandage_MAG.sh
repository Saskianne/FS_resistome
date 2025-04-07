


module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate Bandage_CLI
    module load gcc/12.3.0
    module load git/2.42.0
    module load qt/5.15.9
    module load gpu-env/gcc-8.5.0

srun --pty --x11 --time=01:00:00 --mem=1000 --nodes=1 --cpus-per-task=1 --partition=base Bandage
