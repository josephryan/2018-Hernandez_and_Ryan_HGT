#!usr/bin/perl
use warnings;
use strict;
use Data::Dumper;

our $PHY = $ARGV[0] or die "usage: $0 PHYLIP\n";
our $dir = $ARGV[1] or die "usage: $0 DIRECTORY\n";
our $META = 'meta_const.txt';
our $NOMETA = 'nometa_const.txt';
our $BM = 'RAxML_bestTree.metatree';
our $BT = 'RAxML_bestTree.ALN';
our $BS = 'RAxML_bootstrap.ALN.bs';

MAIN: {
    my $rh_t = get_taxa ($PHY);
    get_comma_sep ($rh_t, 0, 0, 0); 
    get_consel_constraints ($rh_t);
    get_bootstraps ($PHY);
    run_consel ($META, $PHY, $BT, $BM, $BS);
    run_SOWH ($META, $PHY);
}

sub run_SOWH {
    opendir DIR, $dir or die "cannot opendir $dir:$!";
    while (my $file = readdir(DIR)){
        system "sowhat --constraint=$META --aln=$PHY --name=SOWH --dir=$dir --raxml_model=PROTGAMMAGTR --rax='raxmlHPC-PTHREADS-SSE3 -T 170'";
        print "$file\n";
    }
    closedir(DIR);
}

sub run_consel {
    system "raxmlHPC -p 1234 -m PROTGAMMAGTR -n ALN -s $PHY";
    system "raxmlHPC -p 1234 -m PROTGAMMAGTR -n metatree -s $PHY -g $META";
    system "cat $BT $BM $BS >> 102trees.tre";
    system "raxmlHPC -f g -m PROTGAMMAGTR -n 102trees -s $PHY -z 102trees.tre";
    system "seqmt --puzzle RAxML_perSiteLLs.102trees;";
    system "makermt RAxML_perSiteLLs;";
    system "consel RAxML_perSiteLLs;";
    system "catpv RAxML_perSiteLLs";
}

sub get_bootstraps {
    system "raxmlHPC -f a -x 12345 -p 12345 -N 100 -m PROTGAMMAGTR -s $PHY -n ALN.bs"
}

sub get_consel_constraints {
    open OUT, ">meta_const.txt" or die "cannot open >meta_const.txt:$!";
    my $rh_t = shift;
    my $csv = get_comma_sep ($rh_t, 1, 1, 1);
    print OUT "(($csv),";
    my $csv2 = get_comma_sep ($rh_t, 0, 0, 0);
    print OUT "$csv2);";
    close OUT;
}

sub get_comma_sep {
    my $rh_t = shift;
    my $meta_flag = shift;
    my $mlei_flag = shift;
    my $funmet_flag = shift;
    my $csv = '';
    foreach my $key (keys %{$rh_t}){
        if ($mlei_flag && $key =~ m/^MLEI/){
            $csv .= "$key,";
        }elsif ($meta_flag && $key =~ m/^MET/){
            $csv .= "$key,";
        }elsif ($meta_flag == 0 && $key !~ m/^FUN\/MET/ && $key !~ m/^M/){
            $csv .= "$key,";
        }elsif ($funmet_flag && $key =~ m/^FUN\/MET/){
            $csv .= "$key,";
        }
    }
    chop $csv;
    return $csv;
}

sub get_taxa {
    my $phy = shift;
    my %taxa = ();
    open IN, $phy or die "cannot open $phy:$!";
    my $first_line = <IN>;
    while (my $line = <IN>){
        my @fields = split /\s+/, $line;
        $taxa{$fields[0]} = 1;
    }
    return \%taxa;
}

