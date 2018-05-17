performed maximum-likelihood analyses using RAxML for each alignment.

## RAxML Commands
`raxmlHPC -p 1234 -m PROTGAMMAGTR -n ALN -s aln.fa-gb.phy`

## max_likelihood_align.tar.gz
alignment files used for maximum-likelihood analyses before pruning

## all_likelihood_trees.tar.gz
**01-PRE_PRUNING** contains all resulting trees from maximum-likelihood analyses before pruning. Trees that were pruned are found in **02-POST_PRUNING**

## no_metazoans.tar.gz
contains alignment files and maximum-likelihood trees for confirmed HGTs that lacked animal BLAST hits
