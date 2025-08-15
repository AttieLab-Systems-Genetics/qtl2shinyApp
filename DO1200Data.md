    rd_dir <- "/Volumes/mkeller3/General/main_directory/mapping_data"

This document concerns local data structures for the `DO1200` data
project conducted in the [AttieLab Systems
Genetics](https://github.com/AttieLab-Systems-Genetics) organization.

## DO1200 Managed Data and Code

The data are maintained on the [UW-Madison
ResearchDrive](https://it.wisc.edu/services/researchdrive/) in the
`mkeller3` partition in `General/main_directory`, primarily in
subfolders

-   `mapping_data/` data objects used for analysis (mapping)
-   `files_for_cross_object/` data used to construct cross object
-   `annotated_peak_summaries/` peak summaries by subject set and
    covariate model

The following code would load the `cross_obj` (2.7Gb) and one of the
peaks dataframe files (`peak_clinical_df`) and one of the phenotype
files. Note that the peaks and phenotype file names have extra
information about project and versions.

    cross_obj <- readRDS(file.path(rd_dir, "cross_DO_diet_grcm39_v6.rds"))
    class <- "clinical_traits"
    peak_clinical_df <- read.csv(file.path(rd_dir, "..", "annotated_peak_summaries",
      paste0("DO1200_", class, "_all_mice_additive_peaks.csv")))
    pheno_clinical_df <- read.csv(file.path(rd_dir, "..", "files_for_cross_object",
      paste0("pheno_", "in_vivo_", class, "_v3.csv")))

The data are maintained with master QTL mapping scripts on GitHub at
[AttieLab-Systems-Genetics/qtl\_mapping/scripts/latest](https://github.com/AttieLab-Systems-Genetics/qtl_mapping/tree/main/scripts/latest).
Note in particular the scan scripts

-   [QTL\_scan\_wrapper.R](https://github.com/AttieLab-Systems-Genetics/qtl_mapping/blob/main/scripts/latest/QTL_scan_wrapper.R)
-   [QTL\_scan\_function.R](https://github.com/AttieLab-Systems-Genetics/qtl_mapping/blob/main/scripts/latest/QTL_scan_function.R)

The wrapper sources the script
[rankz.R](https://github.com/AttieLab-Systems-Genetics/qtl_mapping/blob/main/scripts/latest/rankz.R)
located in the same folder for the data transformation.

## DO1200 Preparation for qtl2shiny

The `DO1200` data are prepared for use with the
[qtl2shiny](https://github.com/byandell-sysgen/qtl2shiny) app. The
intent is to largely maintain data in the structure as the above managed
data, with adjustments for rapid access and use. Some processing is
done, for instance to put data in RDS files for quicker access and to
combine disparate phenotype files.

CSV files were transferred by hand, read and saved as RDS. For instance,
peaks came from RD folder `annotated_peak_summaries` as CSV files, and
landed in `qtl2shinyData/CCmouse/DO1200/peaks` as RDS files.

Key sections:

-   [Project and CC Mouse Data](#project-and-cc-mouse-data)
    -   [Miscellaneous Items from Cross
        Object](#miscellaneous-items-from-cross-object)
-   [DO1200 Genotype Data](#do1200-genotype-data)
    -   [Kinship](#kinship)
    -   [Genes and SNP Variants](#genes-and-snp-variants)
    -   [Genotype Probabilities](#genotype-probabilities)
-   [DO1200 Peak Data](#do1200-peak-data)
-   [DO1200 Phenotype Data](#do1200-phenotype-data)
    -   [DO1200 Covariate Data](#do1200-covariate-data)
    -   [DO1200 Phenotypes by Class](#do1200-phenotypes-by-class)

<hr>

## Project and CC Mouse Data

The project is identified at the top level in a CSV file `projects.csv`

    project,taxa,directory
    Recla,CCmouse,qtl2shinyData
    DO1200,CCmouse,qtl2shinyData

Each row corresponds to a project. The `project` is located within a
`taxa`, which is located within the overall `qtl2shinyData` folder. For
ease, we define the project info below.

    (project_df <- data.frame(project = "DO1200",
                               taxa = "CCmouse",
                               directory = "qtl2shinyData"))

    ##   project    taxa     directory
    ## 1  DO1200 CCmouse qtl2shinyData

    taxa_path <- file.path(project_df$directory, project_df$taxa)
    dir(taxa_path)

    ##  [1] "allele_info.rds"           "AttieDO"                  
    ##  [3] "AttieDO.Rmd"               "AttieDOv2"                
    ##  [5] "AttieDOv2.Rmd"             "cc_variants_grcm39.sqlite"
    ##  [7] "cc_variants.sqlite"        "DO1200"                   
    ##  [9] "mouse_genes_grcm39.sqlite" "mouse_genes_mgi.sqlite"   
    ## [11] "mouse_genes.sqlite"        "query_genes grcm38.rds"   
    ## [13] "query_genes_grcm39.rds"    "query_genes.rds"          
    ## [15] "query_variants grcm38.rds" "query_variants_grcm39.rds"
    ## [17] "query_variants.rds"        "README.md"                
    ## [19] "Recla"                     "taxa_info.rds"            
    ## [21] "toShiny.sh"

    (project_path <- file.path(taxa_path, project_df$project))

    ## [1] "qtl2shinyData/CCmouse/DO1200"

    if(!dir.exists(project_path)) dir.create(project_path, recursive = TRUE)

    dir(project_path)

    ##  [1] "covar.csv"       "covar.rds"       "kinship.rds"     "misc"           
    ##  [5] "peaks"           "pheno"           "pmap.rds"        "probs_fst"      
    ##  [9] "query_probs.rds" "README.md"

The filesystem organization is as follows (focused on `DO1200` project)

    qtl2shinyApp/
    ├── README.md                           # Overall README file
    ├── .gitignore                          # Git ignore file
    ├── DO1200Data.Rmd                      # This file
    ├── DO1200Study.Rmd                     # Initial DO1200 study and analysis
    ├── app.R                               # qtl2shiny app
    ├── projects.csv                        # project information
    # following folders are **not** maintained on GitHub
    ├── qtl2shinyData/                      # data directory
        └── CCmouse                         # CC mouse taxa directory
            ├── allele_info.rds.            # CC mouse allele information
            ├── mouse_genes_grcm39.sqlite   # SQLite database for variants
            ├── cc_variants_grcm39.sqlite   # SQLite database for genes
            ├── query_variants_grcm39.rds   # query function for variants
            ├── query_genes_grcm39.rds      # query function for genes
            └── DO1200                      # directory for DO1200 project

with files in the `DO1200` folder organized as follows

    DO1200/
    ├── README.md                           # project overview file
    ├── query_probs.rds                     # query function for genoprobs`
    ├── peak/                               # peak summary objects by class & model
        └── DO1200_<class>_<model>_peaks.rds # peak file for a class & model
    ├── pheno/                              # phenotype data matrices by class
        └── pheno_<class>.rds               # phenotype data matrix for a class
    ├── probs_fst/ or genoprob/             # genoprobs in `qtl2fst` format
    ├── covar.rds                           # covariate data frame
    ├── kinship_loco.rds                    # kinship object (list)
    └── pmap.rds                            # physical map object (list)

### Miscellaneous Items from Cross Object

The cross object is huge and takes a long time to load. Most of its
elements can be copied from the ResearchDrive. However, it was
convenient to (one time) save the various miscellaneous objects into a
folder.

    if(!file.exists(file.path(project_path, "covar.rds"))) {
      cross <- readRDS(file.path(rd_dir, "cross_DO_diet_grcm39_v6.rds"))
      cross$pheno <- NULL
      cross$geno <- NULL
      # Pull out individual objects.
      for(x in names(cross)) {
        savepath <- file.path(project_path, "misc", paste0(x, ".rds"))
        print(savepath)
        if(!file.exists(savepath)) {
          saveRDS(cross[[x]], savepath)
        }
      }
    }

    sum_na <- function(x) sum(!is.na(x))

    print("Generation (or wave) of each mouse.")

    ## [1] "Generation (or wave) of each mouse."

    table(qtl2shiny::read_project(project_df, "cross_info", "misc"))

    ## 
    ##  41  42  43  44  45  46  47 
    ##  96  97 192 191 194 190 197

    print("Gene information; includes mus-human comparisons.")

    ## [1] "Gene information; includes mus-human comparisons."

    gene_annos <- qtl2shiny::read_project(project_df, "gene_annos", "misc")
    is_human <- grep("hum", names(gene_annos))
    sapply(gene_annos[,-is_human], sum_na)

    ##          gene_id         gene_chr       gene_start         gene_end 
    ##            78298            78298            78298            78298 
    ##      gene_strand      gene_symbol        gene_type gene_description 
    ##            78298            56415            78298            78111 
    ## transcript_count    gene_synonyms 
    ##            78298            23750

    sapply(gene_annos[is_human], sum_na)

    ##     human_hom_gene_id human_hom_gene_symbol         human_hom_chr 
    ##                 20487                 20355                 20487 
    ##       human_hom_start         human_hom_end  human_hom_ortho_type 
    ##                 20487                 20487                 20487 
    ##    hum_to_mus_perc_id    mus_to_hum_perc_id         human_hom_goc 
    ##                 20487                 20487                 19364 
    ##         human_hom_wga        human_hom_conf 
    ##                 20487                 20487

    print("Isoform transcript information; includes mus-human comparisons.")

    ## [1] "Isoform transcript information; includes mus-human comparisons."

    transcript_annos <- qtl2shiny::read_project(project_df, "transcript_annos", "misc")
    is_human <- grep("hum", names(transcript_annos))
    sapply(transcript_annos[,-is_human], sum_na)

    ##           transcript_id          transcript_chr        transcript_start 
    ##                  278375                  278375                  278375 
    ##          transcript_end       transcript_strand       transcript_symbol 
    ##                  278375                  278375                  218795 
    ##         transcript_type transcript_is_canonical                 gene_id 
    ##                  278375                  278375                  278375 
    ##                gene_chr              gene_start                gene_end 
    ##                  278375                  278375                  278375 
    ##             gene_strand             gene_symbol               gene_type 
    ##                  278375                  218795                  278375 
    ##        gene_description        transcript_count           gene_synonyms 
    ##                  278186                  278375                  114497

    sapply(transcript_annos[is_human], sum_na)

    ##     human_hom_gene_id human_hom_gene_symbol         human_hom_chr 
    ##                 95714                 95563                 95714 
    ##       human_hom_start         human_hom_end  human_hom_ortho_type 
    ##                 95714                 95714                 95714 
    ##    hum_to_mus_perc_id    mus_to_hum_perc_id         human_hom_goc 
    ##                 95714                 95714                 94591 
    ##         human_hom_wga        human_hom_conf 
    ##                 95714                 95714

    print("Genotype of founder across all markers (1,2,3).")

    ## [1] "Genotype of founder across all markers (1,2,3)."

    sapply(qtl2shiny::read_project(project_df, "founder_geno", "misc"), dim)

    ##         1    2    3    4    5    6    7    8    9   10   11   12   13   14   15
    ## [1,]    8    8    8    8    8    8    8    8    8    8    8    8    8    8    8
    ## [2,] 8311 8404 6247 6428 6353 6268 6136 5561 5719 5309 6174 5018 5135 4911 4408
    ##        16   17   18   19    X
    ## [1,]    8    8    8    8    8
    ## [2,] 4224 4150 3872 3023 3897

    rm(sum_na, gene_annos, transcript_annos, is_human)

## DO1200 Genotype Data

### Maps

    DO1200/pmap.rds
    DO1200/misc/gmap.rds

### Kinship

    DO1200/kinship.rds from k_loco_DO_diet_grcm39.rds

Kinship file `kinship_loco` is renamed `kinship`.

    if(!file.exists(kinship_rds <- file.path(project_path, "kinship.rds"))) {
      kinship <- readRDS(file.path(rd_dir, "k_loco_DO1200_grcm39.rds"))
      saveRDS(kinship, kinship_rds)
    }

    sapply(qtl2shiny::read_project(project_df, "kinship"), dim)

    ##         1    2    3    4    5    6    7    8    9   10   11   12   13   14   15
    ## [1,] 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157
    ## [2,] 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157
    ##        16   17   18   19    X
    ## [1,] 1157 1157 1157 1157 1157
    ## [2,] 1157 1157 1157 1157 1157

### Genotype Probabilities

Separate FST collections for alleles, allele pairs and SNPs. These take
a long time to copy.

    probs_fst/

    list.files(file.path(rd_dir, "probs_fst"), pattern = "*.rds")

    ## [1] "alleleprobs_fstindex.rds" "genoprobs_fstindex.rds"  
    ## [3] "snpprobs_fstindex.rds"

    if(!dir.exists(file.path(project_path, "probs_fst"))) {
      system(paste0("cp -r ", file.path(rd_dir, "probs_fst"), " ", project_path))
    }

    dim(readRDS(file.path(project_path, "probs_fst", "alleleprobs_fstindex.rds")))

    ##        1    2    3    4    5    6    7    8    9   10   11   12   13   14   15
    ## ind 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157
    ## gen    8    8    8    8    8    8    8    8    8    8    8    8    8    8    8
    ## mar 8311 8404 6247 6428 6353 6268 6136 5561 5719 5309 6174 5018 5135 4911 4408
    ##       16   17   18   19    X
    ## ind 1157 1157 1157 1157 1157
    ## gen    8    8    8    8    8
    ## mar 4224 4150 3872 3023 3897

    dim(readRDS(file.path(project_path, "probs_fst", "genoprobs_fstindex.rds")))

    ##        1    2    3    4    5    6    7    8    9   10   11   12   13   14   15
    ## ind 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157
    ## gen   36   36   36   36   36   36   36   36   36   36   36   36   36   36   36
    ## mar 8311 8404 6247 6428 6353 6268 6136 5561 5719 5309 6174 5018 5135 4911 4408
    ##       16   17   18   19    X
    ## ind 1157 1157 1157 1157 1157
    ## gen   36   36   36   36   44
    ## mar 4224 4150 3872 3023 3897

    dim(readRDS(file.path(project_path, "probs_fst", "snpprobs_fstindex.rds")))

    ##        1    2    3    4    5    6    7    8    9   10   11   12   13   14   15
    ## ind 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157 1157
    ## gen    3    3    3    3    3    3    3    3    3    3    3    3    3    3    3
    ## mar 8020 8131 6061 6207 6121 6034 5935 5378 5556 5109 5993 4873 4966 4723 4275
    ##       16   17   18   19    X
    ## ind 1157 1157 1157 1157 1157
    ## gen    3    3    3    3    5
    ## mar 4093 4000 3755 2931 3706

Use `create_probs_query_func` from package ‘qtl2pattern’ to query
genotype probabilities. Save it in RDS format for later use. Note that
it requires a relative address to the project data provided by
`project_path`.

    if(file.exists(qname <- file.path(project_path, "query_probs.rds"))) {
      warning(paste("probs query", qname,
                    "already exists and will not be overwritten"))
    } else {
      query_probs <- qtl2pattern::create_probs_query_func(
        project_path, probdir = "probs_fst")
      saveRDS(query_probs, qname)
    }

### Genes and SNP Variants

\*\*This is not quite right. Need to know where these came from
(`from_path`). Copying these files takes a long time.

    sql_files <- paste0(c("mouse_genes", "cc_variants"), "_grcm39.sqlite")
    if(!all(file.exists(file.path(taxa_path, sql_files)))) {
      for(i in sql_files) {
        message("copying ", i)
        system(paste0("cp ", file.path(from_path, i), " ", taxa_path))
      }
    }

Need to construct `query_variants.rds` and `query_genes.rds`. Look on
qtl2shiny vignette
[qtl2shinyData.Rmd](https://github.com/byandell-sysgen/qtl2shiny/blob/master/vignettes/qtl2shinyData.Rmd).
\*\* Need to modify code to distinguish from old `gmc38` versions.\*\*

    if(file.exists(qname <- file.path(taxa_path, "query_genes_grcm39.rds"))) {
      warning(paste("gene query", qname,
                    "already exists and will not be overwritten"))
    } else {
      query_genes <- 
        qtl2::create_gene_query_func(
          file.path(taxa_path, "mouse_genes_grcm39.sqlite"))
      saveRDS(query_genes, qname)
    }

    ## Warning: gene query qtl2shinyData/CCmouse/query_genes_grcm39.rds already exists
    ## and will not be overwritten

    if(file.exists(qname <- file.path(taxa_path, "query_variants_grcm39.rds"))) {
      warning(paste("variant query", qname,
                    "already exists and will not be overwritten"))
    } else {
      query_variants <- 
        qtl2::create_variant_query_func(
          file.path(taxa_path, "cc_variants_grcm39.sqlite"))
      saveRDS(query_variants, qname)
    }

    ## Warning: variant query qtl2shinyData/CCmouse/query_variants_grcm39.rds already
    ## exists and will not be overwritten

### SQL for genes and variants

    CCmouse/mouse_genes_grcm39.sqlite
    CCmouse/cc_variants_grcm39.sqlite

    for(i in c("mouse_genes", "cc_variants"))
    system(paste0("cp ",
                  file.path(rd_dir, paste0(i, "_grcm39.sqlite")),
                  " ",
                  taxa_path))

Need to construct `query_variants.rds` and `query_genes.rds`. Look on
qtl2shiny vignette
[qtl2shinyData.Rmd](https://github.com/byandell-sysgen/qtl2shiny/blob/master/vignettes/qtl2shinyData.Rmd).

    if(file.exists(qname <- file.path(taxa_path, "query_genes.rds"))) {
      warning(paste("gene query", qname,
                    "already exists and will not be overwritten"))
    } else {
      query_genes <- 
        qtl2::create_gene_query_func(
          file.path(taxa_path, "mouse_genes_grcm39.sqlite"))
      saveRDS(query_genes, qname)
    }

    if(file.exists(qname <- file.path(taxa_path, "query_variants.rds"))) {
      warning(paste("variant query", qname,
                    "already exists and will not be overwritten"))
    } else {
      query_variants <- 
        qtl2::create_variant_query_func(
          file.path(taxa_path, "cc_variants_grcm39.sqlite"))
      saveRDS(query_variants, qname)
    }

## DO1200 Phenotype Data

### DO1200 Covariate Data

Covariates were already retrieved from the `cross` object. They are also
available as CSV from the `files_for_cross_object` folder. The
`covar_df` object is a dataframe with mouse ID as `rownames`.

    if(!file.exists(covar_rds <- file.path(project_path, "covar.rds"))) {
      covar_df <- readRDS(file.path(rd_dir, "..", "files_for_cross_object",
                                    "covar.csv"))
      saveRDS(covar_df, covar_rds)
    }

### DO1200 Phenotypes by Class

    DO1200/pheno/

Phenotypes are organized by classes. The raw data come from

    dir(file.path(rd_dir, "../files_for_cross_object"), pattern = "^pheno_.*")

    ## [1] "pheno_in_vivo_clinical_traits_v3.csv"                                  
    ## [2] "pheno_liver_genes_DO_diet_nonzero150_vsd_v3.csv"                       
    ## [3] "pheno_liver_isoforms_DO_diet_nonzero150_vsd_v3.csv"                    
    ## [4] "pheno_liver_lipids_combat_corrected.csv"                               
    ## [5] "pheno_liver_psi_DO_diet_nonzero150_qqnorm_v2.csv"                      
    ## [6] "pheno_plasma_13C_metabolite_GTT_metatraits_DO_diet_batch_corrected.csv"
    ## [7] "pheno_plasma_2H_metabolite_GTT_metatraits_DO_diet_batch_corrected.csv"

The data were copied over as CSV, read, and saved as RDS. These files
have Mouse as first column, so are data frames. They are saved in cross
object as matrix with rownames being Mouse ID.

Right now they are saved as `pheno_<class>.rds` as dataframe, but might
be better as `pheno/<class>.rds` as matrix with rownames, since that is
how they will be used.

Note that translation from CSV to RDS can introduce artefacts, such as
`"#DIV/0!"` errors.

The `misc` file `phenocovar` has information across all phenotypes and
covariates. This is not used here.

    table(qtl2shiny::read_project(project_df, "phenocovar", "misc")$dataset)

    ## 
    ##    clinical_traits        liver_genes     liver_isoforms       liver_lipids 
    ##                124              28045              85394                420 
    ## liver_splice_juncs plasma_metabolites 
    ##             162080                190

### Classes and Phenotypes

Phenotypes are organized by `class`. Here are the pheno files on the RD
server, with changes of `class` as developed below to agree with `class`
of `peaks`.

    classes <- dir(file.path(rd_dir, "..", "files_for_cross_object"),
                    pattern = "pheno_.*")
    class_names <- stringr::str_replace(
      stringr::str_remove(
        stringr::str_remove(
          stringr::str_remove(
            stringr::str_remove(
              stringr::str_remove(classes, ".csv$"),
              "_v[0-9]+$"),
            "_(DO_diet_batch|DO_diet|combat)_(corrected|nonzero150_qqnorm|nonzero150_vsd)"),
          "^pheno_"),
        "(in_vivo_|_GTT_metatraits)"),
      "((13C|2H))_metabolite", "metabolites_\\1")
    names(classes) <- class_names
    classes

    ##                                                          clinical_traits 
    ##                                   "pheno_in_vivo_clinical_traits_v3.csv" 
    ##                                                              liver_genes 
    ##                        "pheno_liver_genes_DO_diet_nonzero150_vsd_v3.csv" 
    ##                                                           liver_isoforms 
    ##                     "pheno_liver_isoforms_DO_diet_nonzero150_vsd_v3.csv" 
    ##                                                             liver_lipids 
    ##                                "pheno_liver_lipids_combat_corrected.csv" 
    ##                                                                liver_psi 
    ##                       "pheno_liver_psi_DO_diet_nonzero150_qqnorm_v2.csv" 
    ##                                                   plasma_metabolites_13C 
    ## "pheno_plasma_13C_metabolite_GTT_metatraits_DO_diet_batch_corrected.csv" 
    ##                                                    plasma_metabolites_2H 
    ##  "pheno_plasma_2H_metabolite_GTT_metatraits_DO_diet_batch_corrected.csv"

The following saves `classes` as `pheno_xxx.rds` with `xxx` the
`class_names`. This is OK for now, but may want to save as FST later.

    if(!file.exists(file.path(project_path, "pheno", "pheno_clinical_traits.rds"))) {
      for(i in names(classes)) {
        savepath <- file.path(project_path, "pheno", paste0("pheno_", i, ".rds"))
        print(savepath)
        pheno_path <- file.path(rd_dir, "..", "files_for_cross_object", classes[i])
        saveRDS(read.csv(pheno_path), savepath)
      }
    }

#### Modify Phenotypes to make Matrices with Class Names

The `classes` above are not quite right. The `plasma_metabolites` need
to be combined, and the `liver_psi` needs to be renamed
`liver_splice_juncs`.

    if(!file.exists(file.path(project_path, "pheno", "pheno_liver_splice_juncs.rds"))) {
      system(paste0("mv ",
                    file.path(project_path, "pheno", "pheno_liver_psi.rds"),
                    " ",
                    file.path(project_path, "pheno", "pheno_liver_splice_juncs.rds")))
    }

    pm <- file.path(project_path, "pheno", "pheno_plasma_metabolites")
    if(!file.exists(paste0(pm, ".rds"))) {
      pm1 <- readRDS(paste0(pm, "_13C.rds"))
      pm2 <- readRDS(paste0(pm, "_2H.rds"))
      pmall <- dplyr::full_join(pm1, pm2, by = "Mouse")
      saveRDS(pmall, paste0(pm, ".rds"))
      system(paste("rm ", paste0(pm, "_13C.rds "), paste0(pm, "_2H.rds")))
      rm(pm1, pm2, pmall)
    }

    classes <- dir(file.path(project_path, "pheno"), pattern = "pheno_.*")
    class_names <- stringr::str_remove(
      stringr::str_remove(classes, "^pheno_"),
      ".rds$")
    names(classes) <- class_names
    classes

    ##                clinical_traits                    liver_genes 
    ##    "pheno_clinical_traits.rds"        "pheno_liver_genes.rds" 
    ##                 liver_isoforms                   liver_lipids 
    ##     "pheno_liver_isoforms.rds"       "pheno_liver_lipids.rds" 
    ##             liver_splice_juncs             plasma_metabolites 
    ## "pheno_liver_splice_juncs.rds" "pheno_plasma_metabolites.rds"

Now, phenotype objects will be changed to have `rownames` as the first
column and saved as matrices.

    phenos <- dir(file.path(project_path, "pheno"), pattern = "pheno_.*")
    for(i in phenos) {
      print(i)
      phenoi <- readRDS(file.path(project_path, "pheno", i))
      if(!is.matrix(phenoi)) {
        phenoi <- tibble::column_to_rownames(phenoi, var = names(phenoi)[1])
        types <- sapply(phenoi, class)
        if(!all(types == "numeric")) {
          for(j in which(types != "numeric"))
            phenoi[[j]] <- as.numeric(phenoi[[j]])
        }
        phenoi <- as.matrix(phenoi)
        saveRDS(phenoi, file.path(project_path, "pheno", i))
      }
    }

### Peaks by Dataset and Covariates by Phenotype

There are many peaks files. Need to decide if plan is to combine peaks
files or have a bunch of different ones. If combined, need columns for
dataset, intset and dietset.

    DO1200/peaks/DO1200_<class>_<model>_peaks.rds

Here are peaks files on RD server for all `class`es with `model`
`all_mice_additive`:

    peaksets <- dir(file.path(rd_dir, "..", "annotated_peak_summaries"),
        pattern = "^.*_all_.*additive_peaks.csv")
    peakset_names <- stringr::str_replace(
      stringr::str_remove(
        stringr::str_remove(peaksets, "^DO1200_"),
        "_all_mice_additive_peaks.csv$"),
      "splice_juncs", "psi")
    names(peaksets) <- peakset_names
    peaksets

    ##                                         clinical_traits 
    ##    "DO1200_clinical_traits_all_mice_additive_peaks.csv" 
    ##                                             liver_genes 
    ##        "DO1200_liver_genes_all_mice_additive_peaks.csv" 
    ##                                          liver_isoforms 
    ##     "DO1200_liver_isoforms_all_mice_additive_peaks.csv" 
    ##                                            liver_lipids 
    ##       "DO1200_liver_lipids_all_mice_additive_peaks.csv" 
    ##                                               liver_psi 
    ## "DO1200_liver_splice_juncs_all_mice_additive_peaks.csv" 
    ##                                      plasma_metabolites 
    ## "DO1200_plasma_metabolites_all_mice_additive_peaks.csv"

and all `peaks` files for class `clinical_traits` with `additive` model,

    dir(file.path(rd_dir, "..", "annotated_peak_summaries"),
        pattern = "^.*_clinical_traits_.*additive_peaks.csv")

    ## [1] "DO1200_clinical_traits_all_mice_additive_peaks.csv"   
    ## [2] "DO1200_clinical_traits_female_mice_additive_peaks.csv"
    ## [3] "DO1200_clinical_traits_HC_mice_additive_peaks.csv"    
    ## [4] "DO1200_clinical_traits_HF_mice_additive_peaks.csv"    
    ## [5] "DO1200_clinical_traits_male_mice_additive_peaks.csv"

and all `peaks` files for class `clinical_traits`.

    dir(file.path(rd_dir, "..", "annotated_peak_summaries"),
        pattern = "^.*_clinical_traits_.*_peaks.csv")

    ##  [1] "DO1200_clinical_traits_all_mice_additive_peaks.csv"             
    ##  [2] "DO1200_clinical_traits_all_mice_diet_interactive_peaks.csv"     
    ##  [3] "DO1200_clinical_traits_all_mice_sex_interactive_peaks.csv"      
    ##  [4] "DO1200_clinical_traits_all_mice_sexbydiet_interactive_peaks.csv"
    ##  [5] "DO1200_clinical_traits_female_mice_additive_peaks.csv"          
    ##  [6] "DO1200_clinical_traits_female_mice_diet_interactive_peaks.csv"  
    ##  [7] "DO1200_clinical_traits_HC_mice_additive_peaks.csv"              
    ##  [8] "DO1200_clinical_traits_HF_mice_additive_peaks.csv"              
    ##  [9] "DO1200_clinical_traits_male_mice_additive_peaks.csv"            
    ## [10] "DO1200_clinical_traits_male_mice_diet_interactive_peaks.csv"

The following code reads all CSV files from RD server and saves locally
as RDS files

    peaknames <- tools::file_path_sans_ext(
      dir(file.path(rd_dir, "..", "annotated_peak_summaries"),
          pattern = "^DO1200_.*peaks.csv"))
    for(peaki in peaknames) {
      print(peaki)
      if(!file.exists(filename <- file.path(project_path, "peaks",
                                            paste0(peaki, ".rds")))) {
        peakcsv <- read.csv(file.path(rd_dir, "..", "annotated_peak_summaries",
                           paste0(peaki, ".csv")))
        print("saved as RDS")
        saveRDS(peakcsv, filename)
      }
    }
