#! /usr/bin/perl -w
use strict;
=pod
description: calculate the TPM for pair-end transcriptome.
author: Liang Yingyi, yyliangchn@163.com
modified date: 20170929
USAGE: perl $0 <lib> <path of merge_RSEM_output_to_matrix.pl> <outputdirection> <reference transcriptome>
=cut

open my $IN, "<", $ARGV[0] or die;
my $outdir=$ARGV[2];
my $ref=$ARGV[3];
my $nl;
`rsem-prepare-reference --bowtie2 -p 6 $ref $outdir/ref_new`;
open my $OUT, ">", "results.list" or die;
for my $i (<$IN>){
	my @l=split /\s/,$i;
	my $fq1=$l[0];
	my $fq2=$l[1];
	my $label=$l[2];
	`rsem-calculate-expression --bowtie2 -p 6 --calc-ci --calc-pme --paired-end $fq1 $fq2 $outdir/ref_new $label`;
	$nl.="$label.isoforms.results ";
	print $OUT "$label.isoforms.results\n";
}

`$ARGV[1]merge_RSEM_output_to_matrix.pl --rsem_files results.list --mode tpm > transcripts.TPM.matrix`;
