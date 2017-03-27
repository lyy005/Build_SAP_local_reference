#! usr/bin/perl -w
use strict;

die "Usage: perl $0 <nt.gz> <output>\n" unless(@ARGV == 2);


###############################
        if ($ARGV[0] =~ /gz$/){
                open IN, "gzip -dc $ARGV[0] |" || die "$!\n";
        } else {
                open IN, "<$ARGV[0]" || die "$!\n";
        }
##############################
my %taxid;
open GI, "gzip -dc nucl_gb.accession2taxid.gz |" || die "$!\n";
while(<GI>){
	my @line = split;
	$taxid{$line[1]} = $line[2];
}
close GI;

# add taxid to fasta
# open OT, ' | gzip -c > '."$ARGV[1].gz" or die "$!\n";
open OT, ">$ARGV[1]" || die "$!\n";

$/ = ">";
<IN>;
while(<IN>){
	chomp;
	my @line = split/\n+/;
	my $name = shift @line;
	my $seq = join "", @line; 

	my @name = split/\s+/, $name;


	if($taxid{$name[0]}){
		print OT ">$name[0] taxid=$taxid{$name[0]};\n$seq\n";
	}else{
		print "$name\n";
	}
}
close IN;
close OT;
