##GenomeSize

Failed attempt to predict genome size with GBS sequencing data

###Plan

Based off of jrossibarra's Gsize repository and method. All due credit to Jeff Ross-Ibarra.

"Here, the idea is that if we have a known quantity of DNA in each line, genome size should negatively correlate with the percent of reads mapping to that known quantity.  We start off using the cDNA.

It turns out a lot fo the cDNA are probably repetitive, as a large number of reads map to them (sometimes 2% of the genome!).  This is clearly unrealistic, and probably due to some TEs being annotated as genes and/or TEs picking up bits of exon of real genes.

Our solution is to filter the set of cDNAs to those that have a beleivable number of reads mapping, and use that as the constant amount of "known" DNA."

Tried this same thing here using Hapmap2 GBS data to map to maize cDNA.  Our suspicion was that it would be lucky if it worked, but worth a shot.  Used the same methods as in the jrossibarra method, with some minor modifications and some new custom code.  

GBS data failed miserably with a maximum correlation of ~.2.  Documenting this pipeline for future use in case we figure something out, and it can be applied to different kinds of sequencing data.

Had problems with some SRA files so not all maize lines end up in the 

###Files

####Data 

cDNA is available on ensemblplants.  File is: Zea_mays.AGPv3.22.cdna.all.fa

Fastq GBS data for Hapmap2 is available on panzea.org through SRA.

Use the sra.sh script to get the sra files.  Convert script to an array to get all runs in the accession.
Use the fastqdump.sh script to convert sra to fastq.  This uses the sratoolkit available on SRA.

Relative genome sizes are from the supplemental of the Chia et al. 2012 Nature Genetics paper.

####Scripts dir

* bwa.sh: First attempt.  Gets percent mapping without correction for TE noise
* bwafix.sh: Aligns data, converts to bam, rmdup
* catfq.sh: Merges bam files from different runs of the same maize line
* get_mapping.sh: Uses Paul's perl script to get mapping data
* get_mapping_2.sh: Second part of the above
* parsesam.pl: Paul's script
* gsize.R: Maps regression and gives correlation in R

####Results dir

* final_percent.txt: tab-delimited file with the mapping data, including percents and relative genome sizes
* map.png: Regression plot of the crappy results

###Analysis

####Indexing

Index the cDNA:

  bwa index Zea_mays.AGPv3.22.cdna.all.fa
  
####First Way

this way didn't correct for suspected TE noise, and is modified from code written by Aldo Carmona Baez, because his code was nicer than what I was going to write. All due credit to him for his initial code which I then modified.  Because of the TE noise, this method was abandoned in the final runs.

~~Use the bwa.sh script to map the fastq files to the cDNA and parse out the desired numbers and percentages.  Make sure to correct for directories and file names.  Written as a loop but easily modified to a much faster array.  Bash array was used, but it would be easier to loop through or array with a directory.  Didn't learn this until after I wrote the code, so I didn't change it.~~

~~Number of unique reads, unique mapped reads, and the ratio of the two are printed.~~


####Map

Use the bwafix.sh script to align the data.  Make sure it's set up for the right directories and files.  This aligns to cDNA, converts SAM to BAM, then removes duplicated reads from PCR error using rmdup.  This last step seemed to yield better results.  Make sure not to change the format of the output file names.  These are necessary for the next step.

####Merge

Use the catfq.sh script to merge all bam files using the samtools merge function.  This keeps all bam files of each maize line together to avoid the possibility of recounting the same mapped genomic region from different Illumina runs.  Make sure the directories, files, and maize lines are correct.  Also check the cut line to make sure it's removing the correct amount of characters off of each name.

####Get Mapping Data

Taken directly from jrossibarra:

"Then we get mapping data (this uses Paul's script and assumes single end reads). May need to tweak headers and list of files names for this script to get it to run appropriately too."

Use the get_mapping.sh script, then the get_mapping_2.sh script. (Uses the parsesam.pl script)

#### Find set of "good" genes

Taken directly from jrossibarra:

"Now we have a list of files names "abundance.blah" that have per-gene counts of reads mapping. We want to use these to filter out genes that have way too many reads mapping and should be removed from our "standard".

First we run through each file, get the total number of reads. Run back through each file and calculate the % of reads mapping to each genes.  We flag any gene that has more than 0.00001% of reads mapping.  We do this across all files, make a list of genes to ignore, and write that to "skip_genes.txt" in the results directory. 

	cut -f 1 <( for i in $( ls abundance*); do  perl -e '@file=<>; $sum=0; foreach(@file){ ($gene,$reads)=split(/,/,$_); $sum+=$reads}; foreach(@file){ ($gene,$reads)=split(/,/,$_); next if $gene=~m/\*/; print "$gene\t",$reads/$sum,"\n" if $reads/$sum>5E-5; }  ' < $i; done ) | sort -n | uniq > skip_genes.txt
	
Note that 5E-5 is not a perfect cutoff.  For some files you may need higher/lower.  Key is to rule out the worst set of repetitive stuff, so probably not more than 5000 genes you want to be removing.

Using the skip_genes.txt file, we run back through each abundance file, and ignore genes that should be skipped, recalculating the reads mapping to our "good" reference, and writing that to a file.

	for i in $( ls abundance*); do  echo "$i,$( perl -e 'open BAD, "<skip_genes.txt"; while(<BAD>){ chomp; $badgenes{$_}=1;}; close BAD; @file=<>; $count=0; $totcount=0; $sum=0; $bigsum=0; foreach(@file){ ($gene,$reads)=split(/,/,$_); $bigsum+=$reads; $totcount+=1; next if $gene=~m/\*/; next if $badgenes{$gene}; $count+=1; $sum+=$reads; } print "$bigsum,$totcount,$sum,$count,",$sum/$bigsum,"\n";' < $i )" ; done > fixed_genes_percent.txt

"
####Map in R

Use the gsize.R script in Rstudio to plot the regression and calculate the correlation.  Example from this trial is in the results directory.
