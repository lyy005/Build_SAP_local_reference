#!usr/bin/perl -w
use strict;

die "Usage: perl $0 [input.fa] [nt.CND2.taxid.list.fin.uniq] [out.fa]\n" unless (@ARGV == 3);
my %hash;
open (LST, $ARGV[1]) or die "$ARGV[1] $!\n";
open OUT, ">$ARGV[2]" or die "$ARGV[2] $!\n";

# my @levels = qw (kingdom phylum class order family genus species);
my @levels = qw (phylum class order family genus species);

while(<LST>){
	chomp;
	my @line = split/\t+/;
	$hash{$line[0]} = $line[1];
}
close LST;

my $id = "000000000";
open (FA, $ARGV[0]) or die "$ARGV[0] $!\n";
while(<FA>){
	if(/>/){
		chomp;
		s/\>//;
		my $header = $_;

		$header =~ s/taxid=//;
		$header =~ s/\;//;

		my @line = split /\s+/, $header;
		my $accession = $line[0];

		if($hash{$line[1]}){
			my @headers = split /\;/,$hash{$line[1]};
			my $c = 0;
#			print OUT ">$line[0] ;";
			print OUT ">$id ;";
			$id ++;

shift @headers;
			my @output;
			foreach (@headers){	
				push @output, " $levels[$c]: $headers[$c]";
				$c ++;
			}
			my $output = join ",", @output;
			print OUT "$output";

			pop @line;
			shift @line;
			my $sp = join " ", @line;
			$sp = $headers[-1]." ".$sp;
			
			print OUT " ; $accession\n";
		}else{
			print "Not found: $line[1]\n";
		}
	}else{
		print OUT;
	}
}

close FA;
close OUT;
print "DONE!";
