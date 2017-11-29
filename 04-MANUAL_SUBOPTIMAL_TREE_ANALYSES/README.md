manual suboptimal trees were created by switching the positions of taxa in clades that consisted of three taxa from the best tree. We created 10 manual suboptimal trees or, in cases with less than 10 trees, as many as could be generated in each analysis for the AU test. To optimize manually generated suboptimal trees we performed maximum likelihood analyses before implementing the AU test.

_We used the following commands to optimize each manually generated suboptimal tree:_

`raxmlHPC -p 1234 -m PROTGAMMAGTR -n suboptree1 -s aln.fa-gb.phy -g RAxMLbestTree1_equalbranch.ALN`

_To run the AU test implemented through CONSEL on the best, metazoan constraint, and manually generated suboptimal trees:_

`cat RAxML_bestTree.ALN RAxML_bestTree.metatree RAxML_bestTree.suboptree1 RAxML_bestTree.suboptree2 RAxML_bestTree.suboptree3 RAxML_bestTree.suboptree4 RAxML_bestTree.suboptree5 RAxML_bestTree.suboptree6 RAxML_bestTree.suboptree7 RAxML_bestTree.suboptree8 RAxML_bestTree.suboptree9 RAxML_bestTree.suboptree10 >> 12trees.tre`

`raxmlHPC -f g -m PROTGAMMAGTR -n 12trees -s aln.fa-gb.phy -z 12trees.tre`

`seqmt --puzzle RAxML_perSiteLLs.12trees`

`makermt RAxML_perSiteLLs`

`consel RAxML_perSiteLLs`

`catpv RAxML_perSiteLLs`

