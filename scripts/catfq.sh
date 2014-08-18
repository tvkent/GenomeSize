#!/bin/bash
#SBATCH -p bigmem
#SBATCH --ntasks=1
#SBATCH --mail-user=tvkent@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH -D /home/tvkent/SRA/alignments
#SBATCH -o /home/tvkent/SRA/alignments/merge-stdout.txt
#SBATCH -e /home/tvkent/SRA/alignments/merge-stderr.txt
#SBATCH -J m
set -e
set -u
#files=bamalignments/*bam
sfiles=bamalignments/*sorted*
#filesn=(SRR836271.KI11.fq.gz.bam SRR836307_307-1.Ki11.fq.gz.bam SRR836342_342-3.Ki11.fq.gz.bam SRR836345_345-3.Ki11.fq.gz.bam SRR836349_349-2.Ki11.fq.gz.bam SRR836350_350-2.Ki11.fq.gz.bam)
#files=(SRR836342_342-1.CML277.fq.gz SRR836349_349-1.CML247.fq.gz SRR836342_342-1.CML333.fq.gz SRR836349_349-1.CML322.fq.gz SRR836271.B97.fq.gz SRR836342_342-1.Mo17.fq.gz SRR836349_349-1.Il14H.fq.gz SRR83$
chianames=(P39 IL14H MS71 OH7B HP301 OH43 TIL05 M162W TIL08 MO17 NC358 B97 KY21 B73 CML322 CML103 MO18W M37W TIL16 CML52 CML277 TX303 TZI8 KI3 CML247 CML228 KI11 NC350 CML333 TIL14 TIL15 TIL11 TIL06 CML69$
#chianames=(KI11)
#for chia in "${chianames[@]}"
#do
#rm $chia.fq.gz
#touch $chia.fq
#gzip $chia.fq
#done
#for i in $files
#do
#samtools sort $i $i.sorted
#done

for name in "${chianames[@]}"
do
merge=
name1=$(echo $name | tr '[A-Z]' '[a-z]')

        for file in $sfiles
        do
        file1=$(echo $file | sed 's/^[^\.]*\.//' | tr '[A-Z]' '[a-z]' | rev | cut -c24- | rev)
        if test "$name1" == "$file1"; then
                merge+="${file} "
        fi
        done
samtools merge bamalignments/$name.bam $merge
done
