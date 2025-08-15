# qtl2shinyApp README

QTL2 Shiny App Operations

This repo has building blocks for operational QTL2 Shiny App
constructed with
[qtl2shiny](https://github.com/byandell-sysgen/qtl2shiny).
The instance will have a folder `qtl2shinyData` that is **not**
synced with GitHub.

In addition to these issues, the modular design of the shiny modules
needs to be refactored.
The modules have many parameters, which is helpful to speed up code
but makes it difficult to follow server logic.

A version of the shiny module structure is laid out in
[Documentation: qtl2hiny](https://github.com/AttieLab-Systems-Genetics/Documentation/blob/main/ShinyApps.md#qtl2shiny-localized-qtl-analysis-and-visualization).
This was created with 
[inst/scripts/network_igraph.Rmd](https://github.com/byandell-sysgen/qtl2shiny/blob/master/inst/scripts/network_igraph.Rmd),
which uses 
[inst/extdata/qtl2shinyEdge.csv](https://github.com/byandell-sysgen/qtl2shiny/blob/master/inst/extdata/qtl2shinyEdge.csv)
and
[inst/extdata/qtl2shinyNode.csv](https://github.com/byandell-sysgen/qtl2shiny/blob/master/inst/extdata/qtl2shinyNode.csv).
The nodes and edges have more information about output and parameters,
but some of the details may differ from current code.
Studying this will help us understand the components--parameters,
intermediate objects, and server logic.

## Data Structure

The local data are maintained with code on GitHub in
[byandell-sysgen/qtl2shinyApp](https://github.com/byandell-sysgen/qtl2shinyApp).
and data in the local folder `qtl2shinyData` (**not** on GitHub--see end of
[.gitignore](https://github.com/byandell-sysgen/qtl2shinyApp/blob/main/.gitignore))
with the following directory structure:

```
qtl2shinyApp/
├── README.md                           # This file
├── .gitignore                          # Git ignore file
├── DO1200Data.Rmd                      # DO1200 data file
├── DO1200Study.Rmd                     # Initial DO1200 study and analysis
├── app.R                               # qtl2shiny app
├── projects.csv                        # project information
# following folders are **not** maintained on GitHub
├── qtl2shinyData/                      # data directory
    └── CCmouse                         # `CCmouse` taxa directory
        ├── allele_info.rds.            # CC mouse allele information
        ├── mouse_genes_grcm39.sqlite   # SQLite database for variants
        ├── cc_variants_grcm39.sqlite   # SQLite database for genes
        ├── query_variants_grcm39.rds   # query function for variants
        ├── query_genes_grcm39.rds      # query function for genes
        ├── Recla                       # directory for Recla project
        ├── DO1200                      # directory for DO1200 project
        └── <project>                   # directory for a project
    └── <taxa>                          # another taxa directory
        ├── ...                         # taxa-specific information
        └── <project>                   # directory for another project
```

A `project` subdirectory is organized (or will be soon) as follows.
Note that the `peak` filenames correspond exactly to those found
on the ResearchDrive.
The `pheno` filenames correspond to the beginnings of those names,
keeping the `phenotype class`; note that a couple RD files
are renamed or combined for consistency with `class` naming
(details below).

```
<project>/
├── README.md                           # project overview file
├── query_probs.rds                     # query function for genoprobs`
├── peak/                               # peak summary objects by class & model
    └── <project>_<class>_<model>_peaks.rds # peak file for a class & model
├── pheno/                              # phenotype data matrices by class
    └── pheno_<class>.rds               # phenotype data matrix for a class
├── probs_fst/ or genoprob/             # genoprobs in `qtl2fst` format
├── covar.rds                           # covariate data frame
├── kinship_loco.rds                    # kinship object (list)
└── pmap.rds                            # physical map object (list)
```

## Related Packages

The package, and related packages
[qlt2pattern](https://github.com/byandell-sysgen/qtl2pattern)
and
[qtl2mediate](https://github.com/byandell-sysgen/qtl2mediate),
were developed around 2010 for the simpler DO500 experiment.
Several changes are needed to accommodate the DO1200 experiment.
Likely path is to tag current version of packages as a branch
(say `legacy`) and create a new branch (say `refactor`).

## Needed Changes

These needed changes include:

- modify data entry to new formats and directory structure
  - initial work in `DO1200Data.Rmd`
  - further use in `DO1200Study.Rmd`
- modify scan (`scan1covar`) to handle new data and extensions
  - `addcovar` and `intcovar` as formula
  - extensions for user-supplied add and int covar modifications
    - `sex` and/or `diet` interactions
    - SNP or other covariates
- modify mediation to handle new data
  - revisit mrna mediator code, which has been dormant

