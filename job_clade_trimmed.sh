#!/bin/bash

#SBATCH --partition=eeb354
#SBATCH --job-name=siph_iqtree
#SBATCH --time=30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8

module load IQ-TREE/1.6.12

iqtree -s portulaca_test_alignment_trimmed.fasta -nt AUTO