#!/bin/bash
#SBATCH -p bigmem
#SBATCH --ntasks=1
#SBATCH -D /home/tvkent/SRA/alignments/bamalignments
#SBATCH -o /home/tvkent/SRA/alignments/bwafix-stdout.txt
#SBATCH -e /home/tvkent/SRA/alignments/bwafix-stderr.txt
#SBATCH --array=1-218
#SBATCH -J bwa
set -e
set -u

files=(SRR836342_342-1.CML277.fq.gz SRR836349_349-1.CML247.fq.gz SRR836342_342-1.CML333.fq.gz SRR836349_349-1.CML322.fq.gz SRR836271_B97.fq.gz SRR836342_342-1.Mo17.fq.gz SRR836349_349-1.Il14H.fq.gz SRR836$
#files=(P39 IL14H MS71 OH7B HP301 OH43 TIL05 M162W TIL08 MO17 NC358 B97 KY21 B73 CML322 CML103 MO18W M37W TIL16 CML52 CML277 TX303 TZI8 KI3 CML247 CML228 KI11 NC350 CML333 TIL14 TIL15 TIL11 TIL06 CML69 TI$
number=${files[$SLURM_ARRAY_TASK_ID-1]}
#for file in "${files[@]}"
#do
#bwa mem -t 2 /home/jri/projects/genomesize/data/Zea_mays.AGPv3.22.cdna.T01.fa data/hm2/"$FILE".1 | samtools view -Su - > bamalignments/$file.bam
../../bwa/bwa mem  ../../Zea_mays.AGPv3.22.cdna.T01.fa ../$number > $number.remove.sam

##sam to bam
samtools view -bS $number.remove.sam | samtools sort - $(echo $number).remove.sorted

##removing duplicated reads
samtools rmdup -s $number.remove.sorted.bam $number.sorted.rmdup.bam

##Calculating total number of unique reads
#n_reads=$(samtools view $file.T01.sorted.bam | cut -f 1 | sort | uniq | wc -l)

##Calculating total number of unique reads mapping
#n_mapping=$(samtools view $file.T01.sorted.bam | cut -f 1,3 | grep -v '*' | cut -f 1 | sort | uniq | wc -l)


##Removing created files
rm $number.remove*

##Calculating percentage
#percentage=$(echo 'scale=4;' $n_mapping/$n_reads | bc -l)

#Printing output
#echo barcode$'\t'$file$'\t'$n_reads$'\t'$n_mapping$'\t'$percentage

#done

