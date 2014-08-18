#!/bin/bash
#SBATCH -p bigmem
#SBATCH --ntasks=1
#SBATCH -D /home/tvkent/SRA/alignments/bamalignments/results
#SBATCH -o /home/tvkent/SRA/alignments/perl-stdout.txt
#SBATCH -e /home/tvkent/SRA/alignments/perl-stderr.txt
#SBATCH -J m
set -e
set -u

module load bwa/0.7.5a

#files=(B73.bam B97.bam CML103.bam CML228.bam CML247.bam CML277.bam CML322.bam CML333.bam CML52.bam CML69.bam HP301.bam IL14H.bam KI11.bam KI3.bam KY21.bam M162W.bam M37W.bam MO17.bam MO18W.bam MS71.bam N$
#FILE=${files[$SLURM_ARRAY_TASK_ID-1]}
#echo $FILE
#gets total reads and mapped reads from bamfile
#samtools view alignments/$FILE | tee >( cut -f 1 | sort -n | uniq | wc -l >results/$FILE.total ) | cut -f 1,3 | grep -v "*" | cut -f 1 | sort -n | uniq | wc -l > results/$FILE.mapped
perl ../../../scripts/parsesam.pl <( samtools view $FILE | sort -n -k 1 ) results/abundance."$FILE".txt
