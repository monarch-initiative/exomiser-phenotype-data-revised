# Analysis of Dependencies for Exomiser Phenotype Data Pipeline

### Ontologies

* SSPOS
    * [http://compbio.charite.de/jenkins/job/zp-owl/lastSuccessfulBuild/artifact/zp.owl](http://compbio.charite.de/jenkins/job/zp-owl/lastSuccessfulBuild/artifact/zp.owl)
    * mammalian-phenotype-ontology/scratch/mp-importer.owl
    * human-phenotype-ontology/scratch/hp-importer.owl 
    * upheno/catalog-v001.xml
    * mammalian-phenotype-ontology/src/ontology/mp.owl 
    * human-phenotype-ontology/hp.owl
    * [https://raw.githubusercontent.com/obophenotype/human-phenotype-ontology/master/hp.obo](https://raw.githubusercontent.com/obophenotype/human-phenotype-ontology/master/hp.obo)
    * [http://purl.obolibrary.org/obo/mp.obo](http://purl.obolibrary.org/obo/mp.obo)
* Upheno
    * upheno/vertebrate.owl 
        * <span style="text-decoration:underline;">some of ZP will also come through here</span>. We need to get rid of this dependency I think.
    * upheno/hp-mp/mp_hp-align-equiv.owl 
        * this is the key file that will need to change. New model won't assert 

**The ontology dependencies have the following problems:**

* GitHub references do not correspond to latest release and may, therefore, contain errors
* GitHub (raw) locations can change and are therefore volatile
* Some pipelines like the zp.owl pipeline on charite are completely outdated
* MP/HP are entering the pipeline in at least three forms, all of which are currently mutually incompatible (due to imports):
    * Mp-edit (through importer)
    * Mp.obo (through purl, i.e. latest release)
    * Mp.owl (through git clone and make)
* Potential for (many) unsatisfiable classes because of conflicting UBERON imports (especially the up-to-date hp/mp ones with the stale upheno ones coming from the x-importer.owl files)

<table>
  <tr>
   <td>
<strong>Analysis of ontology dependencies</strong>
<ul>

<li>Unsatisfiable classes (inconsistent imports) is currently the greatest risk

<li>Redundancies (the many different ways ontologies enter the pipeline) can cause problems, like conflicting terms term sets (the set of existing HPO terms may be slightly different in various parts of the pipeline)

<li>Outdated ontologies preclude the inclusion of an unknown number of up-to-date g2ps (esp. Zebrafish)		
</li>
</ul>
   </td>
  </tr>
  <tr>
   <td><strong>Suggestions for improvements</strong>
<ul>

<li><strong>Preliminary solution to make everything work again quickly</strong> 
<ul>
 
<li>List the actual minimal dependencies, and refer to them as purls (ideally bases)  
<ul>
  
<li><a href="http://purl.obolibrary.org/obo/hp/hp-base.owl">http://purl.obolibrary.org/obo/hp/hp-base.owl</a>
  
<li><a href="http://purl.obolibrary.org/obo/zp/zp-base.owl">http://purl.obolibrary.org/obo/zp/zp-base.owl</a>
  
<li>Anything else
</li>  
</ul>
 
<li>Generate imports specifically for the exomiser pipeline
 
<li>Once they exist, replace inputs to uPheno modules who are specifically designed for the process
 
<li>Host phenodigm scores as part of Monarch, assign purls
 
<li>We should get rid of all obo dependencies and replace by flat files
</li> 
</ul>

<li><strong><span style="text-decoration:underline;">Perfect solution: </span></strong> 
<ul>
 
<li>The exomiser dependency on this entire pipeline should be reduced to<strong><span style="text-decoration:underline;"> purls to the three tables of phenodigm scores</span></strong> (which can be downloaded into the database)<strong><span style="text-decoration:underline;"> and a bunch of tables with labels and i</span></strong>	  
<ul>
  
<li>Inspired by <a href="https://github.com/obophenotype/upheno/tree/master/mappings">https://github.com/obophenotype/upheno/tree/master/mappings</a>
  
<li>We should <strong>define a reliable schema for the above tables and a protocol for their extension</strong> (adding new columns etc)!
</li>  
</ul>
</li>  
</ul>

<li>After meeting with Jules and Damian: 
<ul>
 
<li>The phenodigm score generation lives in a separate repo, and exomiser data ingest merely references the three phenodigm score tables
 
<li>The phenodigm score tables should get individual IC scores for all three classes in there (query, match, lcs)
 
<li>A separate branch should try to replace OWLSIM 2 with OWLSIM 3, but for now be conservative (low prio)
 
<li>The remaining ontology dependencies (mp, hp, zp) should be replaced by two tables  
<ul>
  
<li>ID|Label|Obsolete
  
<li>ID|ALT ID
</li>  
</ul>
 
<li>We will have a monarch data release directory which contains up to date dumps for all of the above (weekly/monthly release)
</li> 
</ul>
</li> 
</ul>
   </td>
  </tr>
</table>



### Monarch Data



* OWLSIM (monarch-owlsim-data/data/)
    * Homo_sapiens/Hs_disease_phenotype.txt
    * Homo_sapiens/Hs_disease_labels.txt
    * Mus_musculus/Mm_gene_phenotype.txt
    * Mus_musculus/Mm_gene_labels.txt
    * Danio_rerio/Dr_gene_phenotype.txt
    * Danio_rerio/Dr_gene_labels.txt
    * [https://raw.githubusercontent.com/monarch-initiative/monarch-owlsim-data/master/data/Danio_rerio/](https://raw.githubusercontent.com/monarch-initiative/monarch-owlsim-data/master/data/Danio_rerio/)
        * Dr_gene_phenotype.txt
        * Dr_gene_labels.txt
        * Dr_phenotype_labels.txt (zp..)
        * equivalence between species-specific phenotype terms.
* Is there any use of [owlsim.cache](https://archive.monarchinitiative.org/latest/owlsim/) (IC scores used for phenogrid) and the individual IC scores?
    * This is where we should unify between Monarch Explorer and Exomiser
* **http://compbio.charite.de/jenkins/job/**
    * **<span style="text-decoration:underline;">hpo.annotations.monthly</span>**/lastSuccessfulBuild/artifact/annotation/
        * ALL_SOURCES_ALL_FREQUENCIES_genes_to_phenotype.txt
            * Only used in phenix
        * diseases_to_genes.txt
    * **<span style="text-decoration:underline;">hpo.annotations</span>**/lastStableBuild/artifact/misc/
        * Phenotype_annotation.tab 
            * (source for disease terms, disease phenotypes, omim phenotypes)
        * “README: _Replace human phenotype annotation files in Monarch git repo as these include common disease and merge together some OMIM and Orphanet entries in a way that does not represent the data in our db_.”

<table>
  <tr>
   <td>
<strong>Analysis of Monarch data dependencies</strong>
<ul>

<li>Outdated g2ps, d2ps and labels are not anymore maintained (2 yr old)

<li>There is no contract as to the contents of these files; its possible that OMIM ids suddenly disappear and are replaced by MONDO ones, and Exomiser expect the former

<li>Referring directly to jenkins jobs physical urls is risky, as evidenced by the outdated reference to zp.owl. The current data references are up to date though.
</li>
</ul>
   </td>
  </tr>
  <tr>
   <td><strong>Suggestions:</strong>
<ol>

<li>Write down a contract for the required data files

<li>Implement the contract and make sure that there is a data purl

<li>Review which of these data files are really needed and/or whether anything is missing

<li><strong><span style="text-decoration:underline;">(Monarch Data team: GO phenotypes need to GO -> There are real ZP classes for these now)</span></strong>
</li>
</ol>
   </td>
  </tr>
</table>

### Exomiser-native data

* [https://github.com/exomiser/Exomiser/blob/eeefb3682c9c7813273deaa2b4dcca2bfcac595e/exomiser-data-phenotype/src/main/resources/data/pheno2gene.txt](https://github.com/exomiser/Exomiser/blob/eeefb3682c9c7813273deaa2b4dcca2bfcac595e/exomiser-data-phenotype/src/main/resources/data/pheno2gene.txt)
    * What is a phenoseries? Is it mapped somehow to phenotypes elsewhere?
* [https://github.com/exomiser/Exomiser/blob/eeefb3682c9c7813273deaa2b4dcca2bfcac595e/exomiser-data-phenotype/src/main/resources/data/tad.pg](https://github.com/exomiser/Exomiser/blob/eeefb3682c9c7813273deaa2b4dcca2bfcac595e/exomiser-data-phenotype/src/main/resources/data/tad.pg)

### Other external data

* [http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/](http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/)
    * <span style="text-decoration:underline;">knownGene.txt.gz</span>
    * kgXref.txt.gz
    * knownGeneMrna.txt.gz
    * knownToLocusLink.txt.gz
* [http://string91.embl.de/newstring_download/protein.links.v9.1/9606.protein.links.v9.1.txt.gz](http://string91.embl.de/newstring_download/protein.links.v9.1/9606.protein.links.v9.1.txt.gz)
* [http://ftp.ebi.ac.uk/pub/databases/genenames/new/tsv/hgnc_complete_set.txt](http://ftp.ebi.ac.uk/pub/databases/genenames/new/tsv/hgnc_complete_set.txt)
* [http://www.orphadata.org/data/xml/En_product6.xml](http://www.orphadata.org/data/xml/En_product6.xml)
* [https://omim.org/static/omim/data/mim2gene.txt](https://omim.org/static/omim/data/mim2gene.txt)
* [https://data.omim.org/downloads/nLKYV3qGSpe-HOV8OfliKA/morbidmap.txt](https://data.omim.org/downloads/nLKYV3qGSpe-HOV8OfliKA/morbidmap.txt)
* [http://www.informatics.jax.org/downloads/reports/](http://www.informatics.jax.org/downloads/reports/)
    * MGI_GenePheno.rpt
    * HOM_MouseHumanSequence.rpt
* [ftp://ftp.ebi.ac.uk/pub/databases/impc/release-5.0/csv/ALL_genotype_phenotype.csv.gz](ftp://ftp.ebi.ac.uk/pub/databases/impc/release-5.0/csv/ALL_genotype_phenotype.csv.gz)
* [http://www.ensembl.org/biomart/martservice?query=](http://www.ensembl.org/biomart/martservice?query=)[out:human_mouse_ensembl_orthologs.txt]
* [https://zfin.org/downloads/Human_orthos.txt](https://zfin.org/downloads/Human_orthos.txt)


## Tool dependencies

* <code>[https://github.com/owlcollab/owltools.git](https://github.com/owlcollab/owltools.git)</code>
    * <code>owltools</code>
    * <code>Oort</code>


## GitHub repository dependencies


* <code>[https://github.com/monarch-initiative/monarch-owlsim-data](https://github.com/monarch-initiative/monarch-owlsim-data)</code>
* <code>[https://github.com/obophenotype/human-phenotype-ontology/](https://github.com/obophenotype/human-phenotype-ontology/)</code>
* <code>[https://github.com/obophenotype/mammalian-phenotype-ontology](https://github.com/obophenotype/mammalian-phenotype-ontology)</code>
    * <code>Running make to generate mp.owl</code>
* <code>[https://github.com/obophenotype/upheno](https://github.com/obophenotype/upheno)</code>

