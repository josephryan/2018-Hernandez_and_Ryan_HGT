#!/usr/bin/perl

use strict;
use warnings;
use List::Util 'shuffle';
use Storable;
use Data::Dumper;

our $SEED      = 420;
our $REPS      = 1000;
our $SAMPLES   = 8;
our $POSITIVES = 6;
our $STOR_MEDIAN = './storable.median';


MAIN: {
    srand($SEED);
    my $rh_median = retrieve($STOR_MEDIAN); 
    delete $rh_median->{'too_low_aQual'};
    delete $rh_median->{'alignment_not_unique'};
    my $rh_medsum = get_sum_of_medians($rh_median);
    my @ids = sort keys %{$rh_median};  # i sort so srand will work
    my $count_gtpos = 0;
    for (1..$REPS) {
        my $count_gthundred = 0;
        my @shuf = List::Util::shuffle(@ids);        
        for (my $i = 0; $i < $SAMPLES; $i++) {
            $count_gthundred++ if ($rh_medsum->{$shuf[$i]} >= 100);
        }
        $count_gtpos++ if ($count_gthundred > $POSITIVES);
    }
    print "\$count_gtpos = $count_gtpos\n";
    my $pval = $count_gtpos / $REPS;
    print "\$pval = $pval\n";
}

sub get_sum_of_medians {
    my $rh_m   = shift;
    my %summed = ();
    foreach my $id (keys %{$rh_m}) {
        foreach my $tp (keys %{$rh_m->{$id}}) {
            $summed{$id} += $rh_m->{$id}->{$tp};
        }
    }
    return \%summed;
}
