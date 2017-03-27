#! usr/bin/perl -w
use strict;
die "perl $0 <taxid list>\n New version of 2013, with suborder and superfamily\n" unless (@ARGV==1);
my (%name, %node, %test, @all);

open NODE, "nodes.dmp" or die "nodes.dmp $!\n";
while(<NODE>){
        chomp;
        my @line = split /\|/,$_;
        $line[0] =~ s/\s+//g;
        $line[1] =~ s/\s+//g;
        my @space = split /\s+/,$line[2];
        shift @space;
        my $new = join " ",@space;
        $node{$line[0]} = $line[1];
        $test{$line[0]} = $new;
}
$name{"NA"} = "NA";
#$test{"NA"} = "NA";
close NODE;

my $query;
#my $name;
open IN, $ARGV[0] or die "$ARGV[0] $!\n";
open OUT, ">$ARGV[0].tmp" or die "$ARGV[0].tmp $!\n";
while(<IN>){
        chomp;
        $query = $_;
#       print "$query";

        if(/\|/){
                print "Error input using a \"|\"\n";
                next;
        }
        my $neo = $query;
        @all = ();
        while(1){
                if(defined $neo){

                }else{
                        print "Error !\t$query\n";
                        last;
                }
                if(exists $test{$neo}){

                }else{
                        print "Error $neo!\t$query\n";
                        last;
                }
                if($test{$neo} eq "kingdom"){
                        $all[0] = $neo;
                }elsif($test{$neo} eq "phylum"){
                        $all[1] = $neo;
                }elsif($test{$neo} eq "class"){
                        $all[2] = $neo;
                }elsif($test{$neo} eq "order"){
                        $all[3] = $neo;
#               }elsif($test{$neo} eq "suborder"){
#                        $all[4] = $neo;
#               }elsif($test{$neo} eq "superfamily"){
#                        $all[5] = $neo;
                }elsif($test{$neo} eq "family"){
                        $all[4] = $neo;
                }elsif($test{$neo} eq  "genus"){
                        $all[5] = $neo;
                }elsif($test{$neo} eq "species"){
                        $all[6] = $neo;
                }
                my $change = $node{$neo};
                $neo = $change;
                if(exists $node{$neo}){

                }else{
                        print "Error $neo!\n";
                        last;
                }
                last if $node{$neo} eq $neo;
        }

        foreach my $a (0 .. 6){
                if(exists $all[$a]){
                }else{
                        $all[$a] = "NA";
                }
        }
        my $all = join ";",@all;
        @all = ();
        print OUT "$query\t$all\n";
}
close IN;
close OUT;

open NAME, "names.dmp"  or die "names.dmp $!\n";
while(<NAME>){
        chomp;
        if(/scientific name/){
                my @line = split /\|/,$_;
                $line[0] =~ s/\s+//g;

                my @space = split /\s+/,$line[1];
                shift @space;
                my $new = join " ",@space;
                $name{$line[0]} = $new;
        }

}
close NAME;

open TMP, "$ARGV[0].tmp" or die "$ARGV[0].tmp $!\n";
open OUT2, ">$ARGV[0].fin" or die "$ARGV[0].fin $!\n";
while(<TMP>){
        chomp;
        my $tax = $_;
	my @line = split /\s+/,$tax;
        my @tax = split /\;/,$line[1];
        foreach my $id (@tax){
#               print "$name{$id}\n";
                push @all,$name{$id};
        }
        my $all = join ";",@all;
        @all = ();
        print OUT2 "$line[0]\t$all\n"
}
close TMP;
close OUT2;
print "DONE!";
