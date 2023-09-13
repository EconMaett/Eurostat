# ************************************************************************
# eurostat  ----
# ************************************************************************
# URL: https://ropengov.github.io/eurostat/
# Feel free to copy, adapt, and use this code for your own purposes.
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

# Survey of Professional Forecasters ----
# URL: https://www.ecb.europa.eu/stats/ecb_surveys/survey_of_professional_forecasters/html/index.en.html

## Load packages ----
library(eurostat)
library(tidyverse)
library(scales)
library(ggtext)


# Perform a simple search and print a table
passengers <- search_eurostat(pattern = "passenger transport")
knitr::kable(head(passengers))



