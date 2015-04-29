#!/bin/bash



rm mlf/train.mlf mlf/test.mlf

echo \#\!MLF\!\# > mlf/train.mlf
#perl make_mlf.pl AUTO data/train/auto*.raw >> mlf/train.mlf 
perl make_mlf.pl PES data/train/pes*.raw >> mlf/train.mlf 
perl make_mlf.pl LOPATA data/train/lopata*.raw >> mlf/train.mlf 
#perl make_mlf.pl KAKTUS data/train/kaktus*.raw >> mlf/train.mlf 
#perl make_mlf.pl VODA data/train/voda*.raw >> mlf/train.mlf 
   
echo \#\!MLF\!\# > mlf/test.mlf
#perl make_mlf.pl AUTO data/test/auto*.raw >> mlf/test.mlf 
perl make_mlf.pl PES data/test/pes*.raw >> mlf/test.mlf 
perl make_mlf.pl LOPATA data/test/lopata*.raw >> mlf/test.mlf 
#perl make_mlf.pl KAKTUS data/test/kaktus*.raw >> mlf/test.mlf 
#perl make_mlf.pl VODA data/test/voda*.raw >> mlf/test.mlf 
 

HCopy -T 1 -C cfg/hcopy.conf -S scripts/train.scp 
HCopy -T 1 -C cfg/hcopy.conf -S scripts/test.scp 

#HCompV -T 7 -I mlf/train.mlf -l AUTO -m -S scripts/train_htk.scp -M hmm0 proto/AUTO
HCompV -T 7 -I mlf/train.mlf -l PES -m -S scripts/train_htk.scp -M hmm0 proto/PES
HCompV -T 7 -I mlf/train.mlf -l LOPATA -m -S scripts/train_htk.scp -M hmm0 proto/LOPATA
#HCompV -T 7 -I mlf/train.mlf -l KAKTUS -m -S scripts/train_htk.scp -M hmm0 proto/KAKTUS
#HCompV -T 7 -I mlf/train.mlf -l VODA -m -S scripts/train_htk.scp -M hmm0 proto/VODA


#HRest -T 7 -I mlf/train.mlf -l AUTO -S scripts/train_htk.scp -M hmm1 hmm0/AUTO
HRest -T 7 -I mlf/train.mlf -l PES -S scripts/train_htk.scp -M hmm1 hmm0/PES
HRest -T 7 -I mlf/train.mlf -l LOPATA -S scripts/train_htk.scp -M hmm1 hmm0/LOPATA
#HRest -T 7 -I mlf/train.mlf -l KAKTUS -S scripts/train_htk.scp -M hmm1 hmm0/KAKTUS
#HRest -T 7 -I mlf/train.mlf -l VODA -S scripts/train_htk.scp -M hmm1 hmm0/VODA

HParse net/oldnetwork net/network

HVite -T 1 -d hmm1 -S scripts/test_htk.scp -i mlf/testout.mlf -w net/network dics/dictionary lists/models

HResults -I mlf/test.mlf lists/models mlf/testout.mlf