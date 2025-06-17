# README

## DO1200 translation for qtl2shiny

See `DO1200.Rmd` for current thoughts.
Key issues are dealing with `analyses_tbl` and `pheno_data`,
which are in archaic form.

See `Recla.Rmd` for workflow largely followed in first two panels
of `qtl2shiny` app.

## GitHub R Code

The key code repo is <https://github.com/byandell-sysgen/qtl2shiny>.
The README gives some idea about dependencies and how to implement.
I have implemented it in \`/data/dev/qtl2shinyApp\` on the server,
complete with the old data. HOWEVER, it requires multiple packages,
which installed in my private R library path.
Below I indicate how I have set this up.

## R Library Paths

To see R library paths, type the following command:

```
> .libPaths()
[1] "/home/byandell@ad.wisc.edu/R/x86_64-pc-linux-gnu-library/4.4"
[2] "/usr/local/lib/R/site-library"
[3] "/usr/lib/R/site-library"
[4] "/usr/lib/R/library"
```

This will give you a list of package names by library:

```
sapply(.libPaths(), list.files)
```

This gives you a data frame of package names and versions by library:

```
lapply(
  .libPaths(),
  function(x)data.frame(installed.packages(x))[,c(1,3)])
```

To get a little fancier, this outputs a CSV file `lib_versions.csv`
that has package name and version in columns by library.

```
out <-   lapply(
  .libPaths(),
  function(x)data.frame(installed.packages(x))[,c(1,3)])
names(out) <- .libPaths()
out <- dplyr::bind_rows(out, .id = "Library")
out <- tidyr::pivot_wider(out, names_from = "Library", values_from = "Version")
write.csv(out, "lib_version.csv")
```

Here is a list with versions of packages used by `qtl2shiny`:

```
          Package byandell local.lib usr.lib
1      assertthat    0.2.1     0.2.1    <NA>
2              DT     0.33      0.33    <NA>
3             fst    0.9.8     0.9.8    <NA>
4           gdata    3.0.1      <NA>    <NA>
5          GGally    2.2.1      <NA>    <NA>
6         ggplot2    3.5.2     3.5.1    <NA>
7    intermediate    1.0.6      <NA>    <NA>
8          plotly   4.10.4    4.10.4    <NA>
9           purrr    1.0.4     1.0.2    <NA>
10           qtl2     0.38      0.36    <NA>
11     qtl2ggplot    1.2.4      <NA>    <NA>
12    qtl2mediate    0.5.5      <NA>    <NA>
13    qtl2pattern    1.2.3      <NA>    <NA>
14          rlang    1.1.6     1.1.4    <NA>
15        RSQLite    2.4.1    2.3.11    <NA>
16          shiny   1.10.0    1.10.0    <NA>
17 shinydashboard    0.7.3      <NA>    <NA>
18          dplyr     <NA>     1.1.4    <NA>
19        stringr     <NA>     1.5.1    <NA>
20          tidyr     <NA>     1.3.1    <NA>
21          tools     <NA>      <NA>   4.4.2
22          utils     <NA>      <NA>   4.4.2
```

At present (and probably OK but clumsy);
only `root` can modify the common site library.
It will be important as we move forward to be able to keep packages
and R versions up to date, so someone (Kelly?) needs the keys.

## Legacy app qtl2shiny on Attie Server

I have installed in my area the qtl2shiny app.
That is, I have loaded packages in my library (see previous section)
and use the file `/data/dev/qtl2shinyApp/app.R` to launch the app.
You will see in that file that it has various package dependencies.
These are useful to have so that at app launch it checks whether these
packages have been updated on CRAN or GitHub.

See also the Rmarkdown `Recla.Rmd` and HTML output to show the key steps
of the first two panels of qtl2shiny for a simplified dataset
from Recla et al. (early eQTL study).
It shows images I shared on Wednesday.

## Updating qtl2shiny app

I include in that folder `/data/dev/qtl2shinyApp` is file `ReadMe\_RD.md`
that gives a brief overview and points to the datafiles on `ResearchDrive`
that I have been examining.
I assume there is some documentation on the workflow somewhere,
but I for now did reverse engineering to find what I needed to begin discovery.

The file DO1200.Rmd is my first pass at reconciling between my legacy approach
(recall, >10 years ago) to workflow and the current, much-improved, workflow.
I have identified the bottlenecks that need to be addressed
(primarily is analyses setup and in handling phenotype data).
I might want some help on this (Kalynn? Sarah?) in coming weeks.

The other help I could use involves deployment,
likely using Docker as you have been doing.
I would need some help getting a Docker container that reads the `app.R`
and properly addresses package dependencies as well as data access.
I would also like to see us have a web page that provides lab entry
to the growing set of apps that run out of our server. (Kalynn? Sarah?)

I don’t think the asks are too big now that I have had a chance
to look over code, and legacy and current data.
I am, of course, happy to do my share on code rather than ask you to deep dive.
But, ...

## Lego-building of Modular Shiny Apps

As I have emphasized in my discussions with you and in the documentation file
[ShinyApps](https://github.com/AttieLab-Systems-Genetics/Documentation/blob/main/ShinyApps.md)
(and recently added repo
[helperApps](https://github.com/byandell/helperApps)),
modularity enables easier code expansion.
And it enables pirating from one app to extend another.
I can see ways to use modules from `qtl2shiny` to extend `qtlApp`.
In addition, there are more recent ideas in the
[foundrShiny](https://github.com/AttieLab-Systems-Genetics/foundrShiny)
that will, I believe, bring useful visualizations of alleles across phenotypes.
This is, naturally, on a longer timeframe.

## Current files in Research Drive

ResearchDrive `mkeller3/General/main_directory/mapping_data`:

```
9.7M Oct 25  2024 mouse_genes_grcm39.sqlite
3.9G Oct 25  2024 cc_variants_grcm39.sqlite
 38M Nov  4  2024 cross_DO_diet_grcm39_v0.rds
 26G Nov  4  2024 genoprobs_DO_diet_grcm39.rds
5.7G Nov  4  2024 alleleprobs_DO_diet_grcm39.rds
5.8G Nov  8  2024 condor_mapping.tar.gz
5.9G Nov 13  2024 home.tar.gz
 44M Dec  2  2024 cross_DO_diet_grcm39_raw_data_v2.rds
 40M Dec  2  2024 cross_DO_diet_grcm39_raw_data_v1.rds
2.0G Dec  2  2024 snpprobs_DO_diet_grcm39.rds
 16K Dec  2  2024 probs_fst/
825K Nov  4  2024 probs_fst/genoprobs_fstindex.rds
823K Nov  4  2024 probs_fst/alleleprobs_fstindex.rds
797K Dec  2  2024 probs_fst/snpprobs_fstindex.rds
 44M Dec 16 14:45 cross_DO_diet_grcm39_raw_data_v3.rds
615M Jan  9 21:20 cross_DO_diet_grcm39_raw_data_v4.rds
 16K Jan 13 10:14 condor_mapping_data/
187M Nov  1  2024 condor_mapping_data/k_loco_DO_diet_grcm39.rds
118B Nov  8  2024 condor_mapping_data/run_these_clinical_traits.csv
 94B Nov  8  2024 condor_mapping_data/covariate_list.csv
615M Jan 13 10:10 condor_mapping_data/cross_DO_diet_grcm39_raw_data_v4.rds
5.7G Jan 13 10:13 condor_mapping_data/alleleprobs_DO_diet_grcm39.rds
6.5G Jan 13 10:32 condor_mapping_data_c0_v4.tar.gz
191M Jan 20 13:59 k_chr_DO_diet_grcm39.rds
187M Jan 20 14:00 k_loco_DO_diet_grcm39.rds
9.3M Jan 20 14:00 k_overall_DO_diet_grcm39.rds
1.8G Feb 20 19:31 cross_DO_diet_grcm39_v4_5.rds
7.3M Mar 13 13:11 cross_snpinfo_DO_diet_grcm39.csv
7.3M Apr  1 11:08 liver_splice_junction_ids.csv
2.0G Apr  1 18:52 cross_DO_diet_grcm39_v5.rds
2.0G May 30 00:25 cross_DO_diet_grcm39_v6.rds
```

ResearchDrive `mkeller3/General/main_directory/annotated_summaries`:

```
947K May  8 17:11 DO1200_clinical_traits_all_mice_additive_peaks.txt
773K May  8 17:12 DO1200_clinical_traits_all_mice_diet_interactive_peaks.txt
773K May  8 17:12 DO1200_clinical_traits_all_mice_diet_interactive_peaks.csv
220M May  8 17:55 DO1200_liver_genes_all_mice_additive_peaks.txt
220M May  8 17:55 DO1200_liver_genes_all_mice_additive_peaks.csv
205M May  8 17:57 DO1200_liver_genes_all_mice_diet_interactive_peaks.txt
205M May  8 17:57 DO1200_liver_genes_all_mice_diet_interactive_peaks.csv
221M May  8 17:58 DO1200_liver_genes_all_mice_sex_interactive_peaks.txt
221M May  8 17:58 DO1200_liver_genes_all_mice_sex_interactive_peaks.csv
 92M May  8 17:59 DO1200_liver_genes_female_mice_additive_peaks.txt
 92M May  8 17:59 DO1200_liver_genes_female_mice_additive_peaks.csv
 90M May  8 18:00 DO1200_liver_genes_female_mice_diet_interactive_peaks.txt
 90M May  8 18:00 DO1200_liver_genes_female_mice_diet_interactive_peaks.csv
 93M May  8 18:01 DO1200_liver_genes_HC_mice_additive_peaks.txt
 93M May  8 18:01 DO1200_liver_genes_HC_mice_additive_peaks.csv
 95M May  8 18:02 DO1200_liver_genes_HF_mice_additive_peaks.txt
 95M May  8 18:02 DO1200_liver_genes_HF_mice_additive_peaks.csv
 97M May  8 18:04 DO1200_liver_genes_male_mice_additive_peaks.txt
 97M May  8 18:04 DO1200_liver_genes_male_mice_additive_peaks.csv
 94M May  8 18:05 DO1200_liver_genes_male_mice_diet_interactive_peaks.txt
 94M May  8 18:05 DO1200_liver_genes_male_mice_diet_interactive_peaks.csv
515M May  8 18:11 DO1200_liver_isoforms_all_mice_additive_peaks.txt
515M May  8 18:11 DO1200_liver_isoforms_all_mice_additive_peaks.csv
485M May  8 18:14 DO1200_liver_isoforms_all_mice_diet_interactive_peaks.txt
485M May  8 18:14 DO1200_liver_isoforms_all_mice_diet_interactive_peaks.csv
519M May  8 18:16 DO1200_liver_isoforms_all_mice_sex_interactive_peaks.txt
519M May  8 18:16 DO1200_liver_isoforms_all_mice_sex_interactive_peaks.csv
220M May  8 18:29 DO1200_liver_isoforms_HC_mice_additive_peaks.txt
220M May  8 18:29 DO1200_liver_isoforms_HC_mice_additive_peaks.csv
224M May  8 18:30 DO1200_liver_isoforms_HF_mice_additive_peaks.txt
224M May  8 18:30 DO1200_liver_isoforms_HF_mice_additive_peaks.csv
1.9M May  8 18:31 DO1200_liver_lipids_all_mice_additive_peaks.txt
1.9M May  8 18:31 DO1200_liver_lipids_all_mice_additive_peaks.csv
2.3M May  8 18:31 DO1200_liver_lipids_all_mice_diet_interactive_peaks.txt
2.3M May  8 18:31 DO1200_liver_lipids_all_mice_diet_interactive_peaks.csv
792M May  8 18:34 DO1200_liver_splice_juncs_all_mice_additive_peaks.txt
792M May  8 18:34 DO1200_liver_splice_juncs_all_mice_additive_peaks.csv
324M May  8 19:00 DO1200_liver_splice_juncs_HF_mice_additive_peaks.txt
324M May  8 19:00 DO1200_liver_splice_juncs_HF_mice_additive_peaks.csv
328M May  8 19:01 DO1200_liver_splice_juncs_HC_mice_additive_peaks.txt
328M May  8 19:01 DO1200_liver_splice_juncs_HC_mice_additive_peaks.csv
819K May 19 13:20 DO1200_clinical_traits_all_mice_sex_interactive_peaks.txt
819K May 19 13:20 DO1200_clinical_traits_all_mice_sex_interactive_peaks.csv
203K May 19 13:22 DO1200_clinical_traits_HC_mice_additive_peaks.txt
203K May 19 13:22 DO1200_clinical_traits_HC_mice_additive_peaks.csv
852K May 19 13:23 DO1200_liver_lipids_HC_mice_additive_peaks.txt
852K May 19 13:23 DO1200_liver_lipids_HC_mice_additive_peaks.csv
1.0M May 19 13:24 DO1200_liver_lipids_HF_mice_additive_peaks.txt
1.0M May 19 13:24 DO1200_liver_lipids_HF_mice_additive_peaks.csv
563M May 19 13:52 DO1200_liver_splice_juncs_all_mice_diet_interactive_peaks.txt
563M May 19 13:52 DO1200_liver_splice_juncs_all_mice_diet_interactive_peaks.csv
197K May 28 11:10 DO1200_clinical_traits_HF_mice_additive_peaks.txt
197K May 28 11:10 DO1200_clinical_traits_HF_mice_additive_peaks.csv
 16K Jun  3 13:57 qtlxcovar_peaks/*
516K May 22 14:49 qtlxcovar_peaks/DO1200_liver_lipids_all_mice_qtlxdiet_lod_profiles.rds
 99M May 22 16:09 qtlxcovar_peaks/DO1200_liver_isoforms_all_mice_qtlxdiet_peaks.csv
1.6M May 22 16:13 qtlxcovar_peaks/DO1200_liver_lipids_all_mice_qtlxdiet_peaks.csv
 38M May 23 17:30 qtlxcovar_peaks/DO1200_liver_genes_all_mice_qtlxdiet_peaks.csv
 42K Jun  2 17:26 qtlxcovar_peaks/DO1200_plasma_2H_metabolites_all_mice_qtlxdiet_peaks.csv
383K Jun  2 17:26 qtlxcovar_peaks/DO1200_plasma_2H_metabolites_all_mice_qtlxdiet_lod_profiles.rds
378K Jun  3 12:50 qtlxcovar_peaks/DO1200_clinical_traits_all_mice_qtlxdiet_peaks.csv
416K Jun  3 12:50 qtlxcovar_peaks/DO1200_clinical_traits_all_mice_qtlxdiet_lod_profiles.rds
525K Jun  3 13:57 qtlxcovar_peaks/DO1200_plasma_13C_metabolites_all_mice_qtlxdiet_peaks.csv
434K Jun  3 13:57 qtlxcovar_peaks/DO1200_plasma_13C_metabolites_all_mice_qtlxdiet_lod_profiles.rds
860K Jun  5 13:37 DO1200_plasma_metabolites_all_mice_additive_peaks.txt
860K Jun  5 13:37 DO1200_plasma_metabolites_all_mice_additive_peaks.csv
878K Jun  5 13:38 DO1200_plasma_metabolites_all_mice_diet_interactive_peaks.txt
878K Jun  5 13:38 DO1200_plasma_metabolites_all_mice_diet_interactive_peaks.csv
1.1M Jun  5 13:39 DO1200_plasma_metabolites_all_mice_sex_interactive_peaks.txt
1.1M Jun  5 13:39 DO1200_plasma_metabolites_all_mice_sex_interactive_peaks.csv
739K Jun  5 13:40 DO1200_plasma_metabolites_HF_mice_additive_peaks.txt
739K Jun  5 13:40 DO1200_plasma_metabolites_HF_mice_additive_peaks.csv
674K Jun  5 13:41 DO1200_plasma_metabolites_HC_mice_additive_peaks.txt
674K Jun  5 13:41 DO1200_plasma_metabolites_HC_mice_additive_peaks.csv
 16K Jun  9 14:17 csv_output/*
144K Jun  9 15:37 chroma.sqlite3
942K Jun  9 15:56 DO1200_clinical_traits_all_mice_additive_peaks.csv
```
