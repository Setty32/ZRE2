+==============================================================================+
|                               DEFINICIA ULOHY                                |
+==============================================================================+
  - snazime sa detekovat nasledovne 4 slova:
    - auto
    - pes
    - kaktus
    - voda
+==============================================================================+
|                                     DATA                                     |
+==============================================================================+
  - zvukovy format WAV
  - single channel (Mono)
  - vzorkovacia frekvencia 8kHz
  - format vzorkovanica 16-bit PCM  - trenovacie data tvorili nahravky clenov tymu - kazdy 3 sety
  - testovacie data boli ziskane nahravanim testovacich subjektov programom 
    audacity - od kazdeho cloveka pochadza kazde zo zvolenych slov 1x
  - celkovo existuje pre kazde z vybranych slov 8 testovacich nahravok
+==============================================================================+
|                                  TRENOVANIE                                  |
+==============================================================================+
  - v nasledujucich prikazoch SLOVO reprezentuje nami zvolene slova
  - vytvorenie Master Label Files
    perl make_mlf.pl SLOVO data/train/SLOVO*.raw >> mlf/train.mlf 
    perl make_mlf.pl SLOVO data/test/SLOVO*.raw >> mlf/test.mlf 
  - parametrizacia  
    HCopy -T 1 -C cfg/hcopy.conf -S scripts/train.scp 
    HCopy -T 1 -C cfg/hcopy.conf -S scripts/test.scp 
  - natrenovanie
    HCompV -T 7 -I mlf/train.mlf -l SLOVO -m -S scripts/train_htk.scp -M hmm0 proto/SLOVO
  - pretrenovanie 
    HRest -T 7 -I mlf/train.mlf -l SLOVO -S scripts/train_htk.scp -M hmm1 hmm0/SLOVO
  - vytvorenie siete HMM
    HParse net/oldnetwork net/network
+==============================================================================+
|                                  TESTOVANIE                                  |
+==============================================================================+
  - testovanie
    HVite -T 1 -d hmm1 -S scripts/test_htk.scp -i mlf/testout.mlf -w net/network dics/dictionary lists/models
  - kontrola vysledkov
    HResults -I mlf/test.mlf lists/models mlf/testout.mlf
+==============================================================================+
|                                   VYSLEDKY                                   |
+==============================================================================+
       ====================== HTK Results Analysis =======================
         Date: Wed May  6 16:05:21 2015
         Ref : mlf/test.mlf
         Rec : mlf/testout.mlf
       ------------------------ Overall Results --------------------------
       SENT: %Correct=93.75 [H=30, S=2, N=32]
       WORD: %Corr=93.75, Acc=93.75 [H=30, D=0, S=2, I=0, N=32]
       ===================================================================
+==============================================================================+
|                                  ZHODNOTENIE                                 |
+==============================================================================+
  - v testoch sa vyskytli dve chyby sposobene znizenou kvalitou testovacich dat
  - z pociatku vznikli problemy pri pouziti nahravok bez orezania pociatocnych
    a koncovych pasazi obsahujucich zasumene ticho co sposobovalo velmi nizku 
    uspesnost
  - po uprave nahravok prebehlo testovanie velmi uspesne
  - zlepsit detekciu by bolo mozne pouzitim vacsieho a rozmanitejsieho 
    trenovacieho datasetu (nas obsahoval prevazne muzske nahravky) 