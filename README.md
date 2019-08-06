# Experimental Pipeline for generating Monarch Flat files
Used by downstream tools such as exomiser

Run `sh odk.sh make all` to create data directories for pipelines

# Important info:

- The last_build_source directory contains the last generated phenodigm score tables used by Exomiser (as of early 2019, but at least a year older)

## The original Exomiser pipeline

Preprocessing:

exomiser_pre.pl


PIPELINE

owltools --catalog-xml upheno/catalog-v001.xml mammalian-phenotype-ontology/scratch/mp-importer.owl mammalian-phenotype-ontology/src/ontology/mp.owl human-phenotype-ontology/hp.owl zp.owl monarch-owlsim-data/data/Mus_musculus/Mm_gene_phenotype.txt monarch-owlsim-data/data/Homo_sapiens/Hs_disease_phenotype.txt monarch-owlsim-data/data/Danio_rerio/Dr_gene_phenotype.txt --merge-imports-closure --load-instances monarch-owlsim-data/data/Mus_musculus/Mm_gene_phenotype.txt --load-labels monarch-owlsim-data/data/Mus_musculus/Mm_gene_labels.txt --merge-support-ontologies -o Mus_musculus-all.owl

owltools --catalog-xml upheno/catalog-v001.xml human-phenotype-ontology/scratch/hp-importer.owl mammalian-phenotype-ontology/src/ontology/mp.owl human-phenotype-ontology/hp.owl zp.owl monarch-owlsim-data/data/Mus_musculus/Mm_gene_phenotype.txt monarch-owlsim-data/data/Homo_sapiens/Hs_disease_phenotype.txt monarch-owlsim-data/data/Danio_rerio/Dr_gene_phenotype.txt --merge-imports-closure --load-instances monarch-owlsim-data/data/Homo_sapiens/Hs_disease_phenotype.txt --load-labels monarch-owlsim-data/data/Homo_sapiens/Hs_disease_labels.txt --merge-support-ontologies -o Homo_sapiens-all.owl

owltools --catalog-xml upheno/catalog-v001.xml upheno/vertebrate.owl mammalian-phenotype-ontology/src/ontology/mp.owl human-phenotype-ontology/hp.owl zp.owl monarch-owlsim-data/data/Mus_musculus/Mm_gene_phenotype.txt monarch-owlsim-data/data/Homo_sapiens/Hs_disease_phenotype.txt monarch-owlsim-data/data/Danio_rerio/Dr_gene_phenotype.txt --load-instances monarch-owlsim-data/data/Danio_rerio/Dr_gene_phenotype.txt --load-labels monarch-owlsim-data/data/Danio_rerio/Dr_gene_labels.txt --load-instances monarch-owlsim-data/data/Homo_sapiens/Hs_disease_phenotype.txt --load-labels monarch-owlsim-data/data/Homo_sapiens/Hs_disease_labels.txt --merge-support-ontologies --merge-imports-closure --remove-disjoints --remove-equivalent-to-nothing-axioms --run-reasoner -r elk --assert-implied --make-super-slim HP,ZP -o hp-zp-all.owl

owltools Homo_sapiens-all.owl --merge-import-closure --remove-disjoints --remove-equivalent-to-nothing-axioms -o Homo_sapiens-all-merged.owl
owltools Mus_musculus-all.owl --merge-import-closure --remove-disjoints --remove-equivalent-to-nothing-axioms -o Mus_musculus-all-merged.owl
owltools hp-zp-all.owl --merge-import-closure --remove-disjoints --remove-equivalent-to-nothing-axioms -o hp-zp-all-merged.owl

OWLTOOLS_MEMORY=14G owltools Homo_sapiens-all-merged.owl --sim-save-phenodigm-class-scores -m 2.5 -x HP,HP -a hp-hp-phenodigm-cache.txt
OWLTOOLS_MEMORY=14G owltools Mus_musculus-all-merged.owl Homo_sapiens-all-merged.owl upheno/hp-mp/mp_hp-align-equiv.owl --merge-support-ontologies --sim-save-phenodigm-class-scores -m 2.5 -x HP,MP -a hp-mp-phenodigm-cache.txt
OWLTOOLS_MEMORY=14G owltools hp-zp-all-merged.owl --sim-save-phenodigm-class-scores -m 2.5 -x HP,ZP -a hp-zp-phenodigm-cache.txt
