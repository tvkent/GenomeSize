##GenomeSize

Failed attempt to predict genome size with GBS sequencing data

###Plan

Based off of jrossibarra's Gsize repository and method. All due credit to Jeff Ross-Ibarra.

"Here, the idea is that if we have a known quantity of DNA in each line, genome size should negatively correlate with the percent of reads mapping to that known quantity.  We start off using the cDNA.

It turns out a lot fo the cDNA are probably repetitive, as a large number of reads map to them (sometimes 2% of the genome!).  This is clearly unrealistic, and probably due to some TEs being annotated as genes and/or TEs picking up bits of exon of real genes.

Our solution is to filter the set of cDNAs to those that have a beleivable number of reads mapping, and use that as the constant amount of "known" DNA."

Tried this same thing here using GBS data to map to cDNA.  Our suspicion was that it would be lucky if it worked, but worth a shot.  Used the same methods as in the jrossibarra method, with some minor modifications and some new custom code.  

GBS data failed miserably with a maximum correlation of ~.2.  Documenting this pipeline for future use in case we figure something out, and it can be applied to different kinds of sequencing data.


###Analysis

####Indexing

Index the cDNA:

  bwa index Zea_mays.AGPv3.22.cdna.all.fa
  
####First Way

this way didn't correct for suspected TE noise, and is modified from code written by Aldo Carmona Baez. All due credit to him for his initial code.  Because of the TE noise, this method was abandoned in the final runs.

~~Use the bwa.sh file to map the fastq files to the cDNA and parse out the desired numbers and percentages.  Make sure to correct for directories and file names.  Written as a loop but easily modified to a much faster array.  Bash array was used, but it would be easier to loop through or array with a directory.  Didn't learn this until after I wrote the code, so I didn't change it.~~

~~Number of unique reads, unique mapped reads, and the ratio of the two are printed.~~


####Map

Use the fgs.sh file to align the data.  Make sure it's set up for the right directories and files.
