## qtl2shinyApp/app.R ##

## Install or update packages and their dependencies.
# Install `devtools` if not already installed
tryCatch(find.package("devtools"), error = function(e) install.packages("devtools"))
# Install qtl2shiny dependencies from CRAN if not already installed.
devtools::install_cran(c("devtools", "yaml", "jsonlite", "data.table"))
devtools::install_cran(c("RcppEigen", "RSQLite"))
devtools::install_cran(c("tidyverse", "RColorBrewer", "fst", "shiny"))
devtools::install_cran(c("shinydashboard", "grid", "gridBase", "gdata"))
devtools::install_cran(c("GGally", "Rcpp", "mnormt", "corpcor", "plotly"))
# Install other qtl2 packages from CRAN.
devtools::install_cran(c("qtl2", "qtl2fst", "qtl2ggplot"))
# Install byandell packages from GitHub.
devtools::install_github("byandell-sysgen/qtl2pattern")
devtools::install_github("byandell-sysgen/intermediate")
devtools::install_github("byandell-sysgen/qtl2mediate")
#devtools::install_github("byandell-sysgen/qtl2shiny")
## Finished installing and updating packages.

projects <- read.csv("qtl2shinyData/projects.csv", stringsAsFactors = FALSE)
ui <- shinydashboard::dashboardPage(skin="red",
  shinydashboard::dashboardHeader(title = "qtl2shiny"),
  shinydashboard::dashboardSidebar(qtl2shiny::mainInput("qtl2shiny")),
  shinydashboard::dashboardBody(qtl2shiny::mainOutput("qtl2shiny"))
)
server <- function(input, output, session) {
  qtl2shiny::mainServer("qtl2shiny", projects)
  # Allow reconnect with Shiny Server.
  session$allowReconnect(TRUE)
}
shiny::shinyApp(ui, server)