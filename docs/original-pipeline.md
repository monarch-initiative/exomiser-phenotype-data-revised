# Notes on the original Exomiser data pipeline

Repository: [https://github.com/exomiser/Exomiser/tree/master/exomiser-data-phenotype](https://github.com/exomiser/Exomiser/tree/master/exomiser-data-phenotype)

## Preprocessing

exomiser_pre.pl ([see here](https://github.com/exomiser/Exomiser/tree/master/exomiser-data-phenotype))

## Process of generating phenodigm scores:

1. Download all sources (mainly git clone)
2. Replace some of the owlsim data files
3. Run some owltools commands
    1. Create Mus_musculus-all.owl
    2. Create Homo_sapiens-all.owl
    3. Create hp-zp-all.owl
    4. Create Homo_sapiens-all-merged.owl
    5. Create Mus_musculus-all-merged.owl
    6. Create hp-zp-all-merged.owl
    7. Create phenodigm scores (final products that are moved to db dir)
        1. Homo_sapiens-all-merged.owl -> hp-hp-phenodigm-cache.txt
        2. Mus_musculus-all-merged.owl + Homo_sapiens-all-merged.owl + upheno/hp-mp/mp_hp-align-equiv.owl -> hp-mp-phenodigm-cache.txt
        3. Hp-zp-all-merged.owl ->hp-zp-phenodigm-cache.txt


# OWLSIM commands review

### COMMAND 1: Generate mus_musculus-all.owl 

Purpose: Intermediate file is used to generate the phenodigm similarity scores

* Wget 
* INPUT:
    * ~~--catalog-xml upheno/catalog-v001.xml ~~
    * ~~mammalian-phenotype-ontology/scratch/mp-importer.owl ~~
    * ~~mammalian-phenotype-ontology/src/ontology/mp.owl ~~
    * [http://purl.obolibrary.org/obo/hp.owl](http://purl.obolibrary.org/obo/hp.owl)
    * [http://purl.obolibrary.org/obo/mp.owl](http://purl.obolibrary.org/obo/mp.owl)
    * ~~human-phenotype-ontology/hp.owl ~~
    * ~~zp.owl ~~
    * monarch-owlsim-data/data/Mus_musculus/Mm_gene_phenotype.txt 
    * monarch-owlsim-data/data/Homo_sapiens/Hs_disease_phenotype.txt 
        * One disease can have many cause of genes
    * ~~monarch-owlsim-data/data/Danio_rerio/Dr_gene_phenotype.txt ~~
* COMMAND:
    * --merge-imports-closure 
    * --load-instances monarch-owlsim-data/data/Mus_musculus/Mm_gene_phenotype.txt
    * --load-labels monarch-owlsim-data/data/Mus_musculus/Mm_gene_labels.txt 
    * --merge-support-ontologies 


### COMMAND 2: Generate homo_sapiens-all.owl 

Purpose: Intermediate file is used to generate the phenodigm similarity scores



* INPUT:
    * ~~--catalog-xml upheno/catalog-v001.xml ~~
    * ~~human-phenotype-ontology/scratch/hp-importer.owl ~~
    * ~~mammalian-phenotype-ontology/src/ontology/mp.owl ~~
    * ~~human-phenotype-ontology/hp.owl ~~
    * ~~zp.owl ~~
    * [http://purl.obolibrary.org/obo/hp.owl](http://purl.obolibrary.org/obo/hp.owl)
    * ~~monarch-owlsim-data/data/Mus_musculus/Mm_gene_phenotype.txt ~~
    * monarch-owlsim-data/data/Homo_sapiens/Hs_disease_phenotype.txt 
    * ~~monarch-owlsim-data/data/Danio_rerio/Dr_gene_phenotype.txt ~~
* COMMAND:
    * --merge-imports-closure 
    * --load-instances monarch-owlsim-data/data/Homo_sapiens/Hs_disease_phenotype.txt 
    * --load-labels monarch-owlsim-data/data/Homo_sapiens/Hs_disease_labels.txt 
    * --merge-support-ontologies 


### COMMAND 3: Generate hp-zp-all.owl 

Purpose: Intermediate file is used to generate the phenodigm similarity scores



* INPUT:
    * ~~--catalog-xml upheno/catalog-v001.xml ~~
    * ~~upheno/vertebrate.owl ~~
    * ~~mammalian-phenotype-ontology/src/ontology/mp.owl~~
    * ~~human-phenotype-ontology/hp.owl ~~
    * ~~zp.owl ~~
    * [http://purl.obolibrary.org/obo/hp.owl](http://purl.obolibrary.org/obo/hp.owl)
    * [http://purl.obolibrary.org/obo/zp.owl](http://purl.obolibrary.org/obo/zp.owl)
    * ~~monarch-owlsim-data/data/Mus_musculus/Mm_gene_phenotype.txt ~~
    * monarch-owlsim-data/data/Homo_sapiens/Hs_disease_phenotype.txt 
    * monarch-owlsim-data/data/Danio_rerio/Dr_gene_phenotype.txt 
* COMMAND:
    * --load-instances monarch-owlsim-data/data/Danio_rerio/Dr_gene_phenotype.txt 
    * --load-labels monarch-owlsim-data/data/Danio_rerio/Dr_gene_labels.txt 
    * --load-instances monarch-owlsim-data/data/Homo_sapiens/Hs_disease_phenotype.txt 
    * --load-labels monarch-owlsim-data/data/Homo_sapiens/Hs_disease_labels.txt 
    * --merge-support-ontologies 
    * --merge-imports-closure 
    * --remove-disjoints 
    * --remove-equivalent-to-nothing-axioms 
    * --run-reasoner -r elk --assert-implied 
    * --make-super-slim HP,ZP

Final OwlSim code being called is here:

[https://github.com/owlcollab/owltools/blob/3c7852e0fabb5d291dc33a4c8f51963af48aa534/OWLTools-Runner/src/main/java/owltools/cli/Sim2CommandRunner.java#L1459-L1544](https://github.com/owlcollab/owltools/blob/3c7852e0fabb5d291dc33a4c8f51963af48aa534/OWLTools-Runner/src/main/java/owltools/cli/Sim2CommandRunner.java#L1459-L1544)

Output of owlsim has underscore instead of : for curies

Final tsv output example:

ID|HP_ID|HP_LABEL|MP_ID|MP_LABEL|SIMJ|IC(lcs)|SCORE(phenodigm)|LCS_ID|LCS_LABEL

1    HP:0010495    Amniotic constriction rings of legs    MP:0001711    abnormal placenta morphology    0.3125    5.055448136114318    1.256911907229669    HP:0001194    Abnormalities of placenta or umbilical cord

2    HP:0010495    Amniotic constriction rings of legs    MP:0001712    abnormal placenta development    0.20833333333333334    5.055448136114318    1.026264274780372   

## OLD COMMANDS

owltools --catalog-xml upheno/catalog-v001.xml mammalian-phenotype-ontology/scratch/mp-importer.owl mammalian-phenotype-ontology/src/ontology/mp.owl human-phenotype-ontology/hp.owl zp.owl monarch-owlsim-data/data/Mus_musculus/Mm_gene_phenotype.txt monarch-owlsim-data/data/Homo_sapiens/Hs_disease_phenotype.txt monarch-owlsim-data/data/Danio_rerio/Dr_gene_phenotype.txt --merge-imports-closure --load-instances monarch-owlsim-data/data/Mus_musculus/Mm_gene_phenotype.txt --load-labels monarch-owlsim-data/data/Mus_musculus/Mm_gene_labels.txt --merge-support-ontologies -o Mus_musculus-all.owl

owltools --catalog-xml upheno/catalog-v001.xml human-phenotype-ontology/scratch/hp-importer.owl mammalian-phenotype-ontology/src/ontology/mp.owl human-phenotype-ontology/hp.owl zp.owl monarch-owlsim-data/data/Mus_musculus/Mm_gene_phenotype.txt monarch-owlsim-data/data/Homo_sapiens/Hs_disease_phenotype.txt monarch-owlsim-data/data/Danio_rerio/Dr_gene_phenotype.txt --merge-imports-closure --load-instances monarch-owlsim-data/data/Homo_sapiens/Hs_disease_phenotype.txt --load-labels monarch-owlsim-data/data/Homo_sapiens/Hs_disease_labels.txt --merge-support-ontologies -o Homo_sapiens-all.owl

owltools --catalog-xml upheno/catalog-v001.xml upheno/vertebrate.owl mammalian-phenotype-ontology/src/ontology/mp.owl human-phenotype-ontology/hp.owl zp.owl monarch-owlsim-data/data/Mus_musculus/Mm_gene_phenotype.txt monarch-owlsim-data/data/Homo_sapiens/Hs_disease_phenotype.txt monarch-owlsim-data/data/Danio_rerio/Dr_gene_phenotype.txt --load-instances monarch-owlsim-data/data/Danio_rerio/Dr_gene_phenotype.txt --load-labels monarch-owlsim-data/data/Danio_rerio/Dr_gene_labels.txt --load-instances monarch-owlsim-data/data/Homo_sapiens/Hs_disease_phenotype.txt --load-labels monarch-owlsim-data/data/Homo_sapiens/Hs_disease_labels.txt --merge-support-ontologies --merge-imports-closure --remove-disjoints --remove-equivalent-to-nothing-axioms --run-reasoner -r elk --assert-implied --make-super-slim HP,ZP -o hp-zp-all.owl

owltools Homo_sapiens-all.owl --merge-import-closure --remove-disjoints --remove-equivalent-to-nothing-axioms -o Homo_sapiens-all-merged.owl
owltools Mus_musculus-all.owl --merge-import-closure --remove-disjoints --remove-equivalent-to-nothing-axioms -o Mus_musculus-all-merged.owl
owltools hp-zp-all.owl --merge-import-closure --remove-disjoints --remove-equivalent-to-nothing-axioms -o hp-zp-all-merged.owl

OWLTOOLS_MEMORY=14G owltools Homo_sapiens-all-merged.owl --sim-save-phenodigm-class-scores -m 2.5 -x HP,HP -a hp-hp-phenodigm-cache.txt
OWLTOOLS_MEMORY=14G owltools Mus_musculus-all-merged.owl Homo_sapiens-all-merged.owl upheno/hp-mp/mp_hp-align-equiv.owl --merge-support-ontologies --sim-save-phenodigm-class-scores -m 2.5 -x HP,MP -a hp-mp-phenodigm-cache.txt
OWLTOOLS_MEMORY=14G owltools hp-zp-all-merged.owl --sim-save-phenodigm-class-scores -m 2.5 -x HP,ZP -a hp-zp-phenodigm-cache.txt
