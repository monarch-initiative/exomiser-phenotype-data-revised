# ----------------------------------------
# Makefile for Monarch Initiative's 
# Ontology Data Pipeline
# ----------------------------------------


# ----------------------------------------
# Constants
# ----------------------------------------

# last_build master
DATA_PIPELINES_NAMES= original_a original_b last_build cleaned
DATA_PIPELINES=$(patsubst %, data/%, $(DATA_PIPELINES_NAMES))
COMPARISONS=hp_hp hp_mp hp_zp
ARTEFACTS=$(patsubst %, %_phenodigm_2_5.txt, $(COMPARISONS))
PHENODIGM_ONTOLOGIES=$(patsubst %, %.owl, $(COMPARISONS))
ALL_PHENODIGM=$(foreach d,$(DATA_PIPELINES), $(foreach n,$(ARTEFACTS), $(d)/$(n)))
ALL_ONTOLOGIES=$(foreach d,$(DATA_PIPELINES), $(foreach n,$(PHENODIGM_ONTOLOGIES), $(d)/$(n)))
HEATMAPS=cleaned/last_build
OT_MEMO=80G
OWLTOOLS=OWLTOOLS_MEMORY=$(OT_MEMO) owltools --no-logging

# ONTOLOGIES
URL_MP=http://purl.obolibrary.org/obo/mp.owl
URL_MP_BASE=http://purl.obolibrary.org/obo/mp/mp-base.owl
URL_HP=http://purl.obolibrary.org/obo/hp.owl
URL_HP_BASE=http://purl.obolibrary.org/obo/hp/hp-base.owl
URL_ZP=http://purl.obolibrary.org/obo/zp.owl
URL_ZP_BASE=http://purl.obolibrary.org/obo/zp/zp-base.owl
URL_MP_HP_EQUIV=http://purl.obolibrary.org/obo/upheno/hp-mp/mp_hp-align-equiv.owl
#URL_MP_IMPORTER=https://raw.githubusercontent.com/obophenotype/mammalian-phenotype-ontology/master/scratch/mp-importer.owl
#URL_HP_IMPORTER=http://purl.obolibrary.org/obo/hp/scratch/hp-importer.owl
URL_UPHENO_VERTEBRATE=http://purl.obolibrary.org/obo/upheno/vertebrate.owl

URL_UPHENO_CAT=http://purl.obolibrary.org/obo/upheno/catalog-v001.xml

# OWLSIM DATA
MONARCH_OWLSIM_DATA=https://raw.githubusercontent.com/monarch-initiative/monarch-owlsim-data/master/data
URL_MP_G2P=$(MONARCH_OWLSIM_DATA)/Mus_musculus/Mm_gene_phenotype.txt
URL_MP_GL=$(MONARCH_OWLSIM_DATA)/Mus_musculus/Mm_gene_labels.txt
URL_HP_D2P=$(MONARCH_OWLSIM_DATA)/Homo_sapiens/Hs_disease_phenotype.txt
URL_HP_DL=$(MONARCH_OWLSIM_DATA)/Homo_sapiens/Hs_disease_labels.txt
URL_ZP_G2P=$(MONARCH_OWLSIM_DATA)/Danio_rerio/Dr_gene_phenotype.txt
URL_ZP_GL=$(MONARCH_OWLSIM_DATA)/Danio_rerio/Dr_gene_labels.txt

# Filenames after download
MP=sources/mp.owl
MP_BASE=sources/mp-base.owl
HP=sources/hp.owl
HP_BASE=sources/hp-base.owl
ZP=sources/zp.owl
ZP_BASE=sources/zp-base.owl
MP_HP_EQUIV=sources/mp_hp-align-equiv.owl
#MP_IMPORTER=sources/mp-importer.owl
#HP_IMPORTER=sources/hp-importer.owl
UPHENO_VERTEBRATE=sources/vertebrate.owl

UPHENO_CAT=sources2/catalog-v001.xml

MP_G2P=sources/Mm_gene_phenotype.txt
MP_GL=sources/Mm_gene_labels.txt
HP_D2P=sources/Hs_disease_phenotype.txt
HP_DL=sources/Hs_disease_labels.txt
ZP_G2P=sources/Dr_gene_phenotype.txt
ZP_GL=sources/Dr_gene_labels.txt

LAST_PHENODIGM_HP_HP=last_build_source/hp-hp-phenodigm-cache.txt.gz
LAST_PHENODIGM_HP_MP=last_build_source/hp-mp-phenodigm-cache.txt.gz
LAST_PHENODIGM_HP_ZP=last_build_source/hp-zp-phenodigm-cache.txt.gz


#####################################################################
# Download File dependencies                                        #
#####################################################################

download_sources: directories
	if ! [ -f $(MP) ]; then robot merge -I $(URL_MP) -o $(MP).tmp.owl && mv $(MP).tmp.owl $(MP); fi
	if ! [ -f $(MP_BASE) ]; then wget $(URL_MP_BASE) -O $(MP_BASE); fi
	if ! [ -f $(HP) ]; then wget $(URL_HP) -O $(HP); fi
	if ! [ -f $(HP_BASE) ]; then wget $(URL_HP_BASE) -O $(HP_BASE); fi
	if ! [ -f $(ZP) ]; then wget $(URL_ZP) -O $(ZP); fi
	if ! [ -f $(ZP_BASE) ]; then wget $(URL_ZP_BASE) -O $(ZP_BASE); fi
	if ! [ -f $(MP_HP_EQUIV) ]; then wget $(URL_MP_HP_EQUIV) -O $(MP_HP_EQUIV); fi
	#if ! [ -f $(MP_IMPORTER) ]; then wget $(URL_MP_IMPORTER) -O $(MP_IMPORTER); fi
	#if ! [ -f $(HP_IMPORTER) ]; then wget $(URL_HP_IMPORTER) -O $(HP_IMPORTER); fi
	if ! [ -f $(UPHENO_VERTEBRATE) ]; then robot merge -I $(URL_UPHENO_VERTEBRATE) -o $(UPHENO_VERTEBRATE).tmp.owl && mv $(UPHENO_VERTEBRATE).tmp.owl $(UPHENO_VERTEBRATE); fi
	if ! [ -f $(UPHENO_CAT) ]; then wget $(URL_UPHENO_CAT) -O $(UPHENO_CAT); fi
	if ! [ -f $(MP_G2P) ]; then wget $(URL_MP_G2P) -O $(MP_G2P); fi
	if ! [ -f $(MP_GL) ]; then wget $(URL_MP_GL) -O $(MP_GL); fi
	if ! [ -f $(HP_D2P) ]; then wget $(URL_HP_D2P) -O $(HP_D2P); fi
	if ! [ -f $(HP_DL) ]; then wget $(URL_HP_DL) -O $(HP_DL); fi
	if ! [ -f $(ZP_G2P) ]; then wget $(URL_ZP_G2P) -O $(ZP_G2P); fi
	if ! [ -f $(ZP_GL) ]; then wget $(URL_ZP_GL) -O $(ZP_GL); fi

#####################################################################
# Original approach (URL REFERENCES TO CURRENT FILES ON MASTER)     #
#####################################################################

data/original_%/hp_mp.owl: sources
	$(OWLTOOLS) --catalog-xml $(UPHENO_CAT) $(MP) $(HP) $(ZP) $(MP_G2P) $(HP_D2P) $(ZP_G2P) $(MP_HP_EQUIV) --merge-imports-closure --load-instances $(MP_G2P) --load-labels $(MP_GL) --merge-support-ontologies -o $@.tmp.owl && \
	$(OWLTOOLS) $@.tmp.owl --merge-import-closure --remove-disjoints --remove-equivalent-to-nothing-axioms -o $@
	
data/original_%/hp_hp.owl: sources
	$(OWLTOOLS) --catalog-xml $(UPHENO_CAT) $(HP) $(MP) $(ZP) $(MP_G2P) $(HP_D2P) $(ZP_G2P) --merge-imports-closure --load-instances $(HP_D2P) --load-labels $(HP_DL) --merge-support-ontologies -o $@.tmp.owl && \
	$(OWLTOOLS) $@.tmp.owl --merge-import-closure --remove-disjoints --remove-equivalent-to-nothing-axioms -o $@

data/original_%/hp_zp.owl: sources
	$(OWLTOOLS) --catalog-xml $(UPHENO_CAT) $(UPHENO_VERTEBRATE) $(MP) $(HP) $(ZP) $(MP_G2P) $(HP_D2P) $(ZP_G2P) --load-instances $(ZP_G2P) --load-labels $(ZP_GL) --load-instances $(HP_D2P) --load-labels $(HP_DL) --merge-support-ontologies --merge-imports-closure --remove-disjoints --remove-equivalent-to-nothing-axioms --run-reasoner -r elk --assert-implied --make-super-slim HP,ZP -o $@.tmp.owl && \
	$(OWLTOOLS) $@.tmp.owl --merge-import-closure --remove-disjoints --remove-equivalent-to-nothing-axioms -o $@

#####################################################################
# Original approach but ontologies are replaced by correct releases #
#####################################################################
# Other changes: no catalog.xml file, no importers, no vertebrate.owl

data/cleaned/hp_mp.owl: sources
	$(OWLTOOLS) $(MP) $(HP) $(ZP) $(MP_G2P) $(HP_D2P) $(ZP_G2P) $(MP_HP_EQUIV) --merge-imports-closure --load-instances $(MP_G2P) --load-labels $(MP_GL) --merge-support-ontologies -o $@.tmp.owl && \
	$(OWLTOOLS) $@.tmp.owl --merge-import-closure --remove-disjoints --remove-equivalent-to-nothing-axioms -o $@
	
data/cleaned/hp_hp.owl: sources
	$(OWLTOOLS) $(HP) $(MP) $(ZP) $(MP_G2P) $(HP_D2P) $(ZP_G2P) --merge-imports-closure --load-instances $(HP_D2P) --load-labels $(HP_DL) --merge-support-ontologies -o $@.tmp.owl && \
	$(OWLTOOLS) $@.tmp.owl --merge-import-closure --remove-disjoints --remove-equivalent-to-nothing-axioms -o $@

data/cleaned/hp_zp.owl: sources
	$(OWLTOOLS) $(MP) $(HP) $(ZP) $(MP_G2P) $(HP_D2P) $(ZP_G2P) --load-instances $(ZP_G2P) --load-labels $(ZP_GL) --load-instances $(HP_D2P) --load-labels $(HP_DL) --merge-support-ontologies --merge-imports-closure --remove-disjoints --remove-equivalent-to-nothing-axioms --run-reasoner -r elk --assert-implied --make-super-slim HP,ZP -o $@.tmp.owl && \
	$(OWLTOOLS) $@.tmp.owl --merge-import-closure --remove-disjoints --remove-equivalent-to-nothing-axioms -o $@
	
#####################################################################
# MASTER APPROACH #
#####################################################################
# ROBOT based, using ontology bases	

data/master/hp_mp.owl: sources
	robot merge -i $(MP_BASE) -i $(HP_BASE) -i $(MP_HP_EQUIV) \
		remove --axioms "disjoints" \
		remove --term owl:Nothing -o $@
	# $(MP_G2P) $(HP_D2P) $(ZP_G2P)
	# --load-instances $(MP_G2P) --load-labels $(MP_GL)
	
data/master/hp_hp.owl: sources
	robot merge -i $(HP_BASE) \
		remove --axioms "disjoints" \
		remove --term owl:Nothing -o $@
		# --load-instances $(HP_D2P) 
		# --load-labels $(HP_DL)

data/master/hp_zp.owl: sources
	robot merge -i $(HP_BASE) -i $(ZP_BASE) \
		remove --axioms "disjoints" \
		remove --term owl:Nothing -o $@ \
		reason -o $@
		#--make-super-slim HP,ZP
		#--load-instances $(ZP_G2P) 
		# --load-labels $(ZP_GL) 
		# --load-instances $(HP_D2P) 
		# --load-labels $(HP_DL)
		
#####################################################################
# Phenodigm scores												                          #
#####################################################################

%/hp_hp_phenodigm_2_5.txt: %/hp_hp.owl
	$(OWLTOOLS) $*/hp_hp.owl --sim-save-phenodigm-class-scores -m 2.5 -x HP,HP -a $@

%/hp_mp_phenodigm_2_5.txt: %/mp_hp.owl
	$(OWLTOOLS) $*/mp_hp.owl --sim-save-phenodigm-class-scores -m 2.5 -x HP,MP -a $@
	
%/hp_zp_phenodigm_2_5.txt: %/zp_hp.owl	
	$(OWLTOOLS) $*/zp_hp.owl --sim-save-phenodigm-class-scores -m 2.5 -x HP,ZP -a $@


#####################################################################
# Last build which is obtained from source                          #
#####################################################################

data/last_build/hp_hp_phenodigm_2_5.txt:
	gunzip -c $(LAST_PHENODIGM_HP_HP) >$@

data/last_build/hp_mp_phenodigm_2_5.txt:
	gunzip -c $(LAST_PHENODIGM_HP_MP) >$@
	
data/last_build/hp_zp_phenodigm_2_5.txt:
	gunzip -c $(LAST_PHENODIGM_HP_ZP) >$@

#####################################################################
# Pipeline                                                          #
#####################################################################

directories:
	mkdir -p $(DATA_PIPELINES) sources sources2 analysis

compare: scripts/heatmap.py
	$(foreach n, $(HEATMAPS), python $< $(n) data hp_hp_phenodigm_2_5.txt analysis/$(n)_hp_hp_phenodigm_2_5.txt)
	#$(foreach n, $(HEATMAPS), python heatmap.py $(n) "hp_mp_phenodigm_2_5.txt")
	#$(foreach n, $(HEATMAPS), python heatmap.py $(n) "hp_zp_phenodigm_2_5.txt")

print_file_headers:
	head -1 $(MP)
	head -1 $(MP_BASE)
	head -1 $(HP)
	head -1 $(HP_BASE)
	head -1 $(ZP)
	head -1 $(ZP_BASE)
	head -1 $(MP_HP_EQUIV)
	head -1 $(UPHENO_VERTEBRATE)
	head -1 $(UPHENO_CAT)
	head -1 $(MP_G2P)
	head -1 $(MP_GL)
	head -1 $(HP_D2P)
	head -1 $(HP_DL)
	head -1 $(ZP_G2P)
	head -1 $(ZP_GL)

touch_all_phenodigm: directories
	touch $(ALL_PHENODIGM)
	touch $(ALL_ONTOLOGIES)

all: touch_all_phenodigm $(ALL_PHENODIGM)

pheno_sources: touch_all_phenodigm $(ALL_ONTOLOGIES)
	
print: 
	echo "Printing all artefacts.."
	echo $(ALL_ONTOLOGIES) $(ALL_PHENODIGM) $(HEATMAPS)