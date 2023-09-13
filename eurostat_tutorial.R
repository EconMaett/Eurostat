# ************************************************************************
# Tutorial for the eurostat R package ----
# ************************************************************************
# URL: https://ropengov.github.io/eurostat/articles/eurostat_tutorial.html
# Feel free to copy, adapt, and use this code for your own purposes.
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

# The eurostat R package is part of the rOpenGov family of packages.

## Installation ----
library(eurostat)

# The following functions are included:
check_access_to_data() # TRUE. Checks access to ec.europe.eu
clean_eurostat_cache() # Clean Eurostat cache.
eu_countries # code, name, label
tgs00026 # unit direct na_item geo time values; Auxiliary data

evaluate <- curl::has_internet()
evaluate # TRUE


## Finding data ----
# get_eurostat_toc() downloads a table of contents of eurostat datasets.
# The values in the column "code" can be used to download a 
# selected dataset:
toc <- get_eurostat_toc()
knitr::kable(tail(toc))

# Note that some datasets, e.g. in the "comext" type are not
# accessible through the standard interface.
?get_eurostat


# codes for the dataset can also be serched in the Eurostat database.
# The Eurostat database gives codes in the Data Navigation Tree after
# every dataset in paranthesis.


# With search_eurostat() you can search the table of contents for 
# particular patterns, e.g., all datasets related to passenger transport.

# the knitr::kable() function produces nice markdown output that you
# can copy into an RMarkdown / Markdown file.
knitr::kable(head(search_eurostat(pattern = "passenger transport")))


## Downloading data ----

# The eurostat package supports two of Eurostats' download methods:
# - The bulk download facility
# - The Web Services' JSON API

# The bulk download facility is the fastest method to download whole
# datasets.
# It is also often the only way as the JSON API is limited to 50
# sub-indicators at a time and whole datasets often exceed that.

# To download only a small section of the dataset, the JSON API
# is faster, as it allows for a data selection before downloading.


# A user does not have to bother with the two methods.
# If only the table id is given, the whole table is downloaded
# from the bulk download facility.

# If filters are also defined, the JSON API is used.

# We take the indicator "Modal split of passenger transport"
# as an example. This is the percentage share of each mode of 
# transport in total inland transport, expressed in passenger-kilometres (pkm)
# based on transport by passenger cars, buses and coaches, and trains.

# All data should be based on movements on national territory, 
# regardless of the nationality of the vehicle.

# However, the data collection is not harmonized at the EU level.

# Pick and print the id of the data set to download:

id <- search_eurostat(pattern = "passenger transport",
                      type = "table")$code[2]
print(id)

# Get the whole corresponding table.
# As the data has annual frequency, it is more convenient to use
# a numeric time variable than the default "Date" format:
dat <- get_eurostat(id = id, time_format = "num")
dat # unit, geo, time, values
str(dat)
knitr::kable(head(dat))

# You can get only a part of the dataset by defining the
# "filters" argument.
# It should be a named list, where names correspond to
# variable names in lower case and values are vectors of codes
# corresponding the desired series (in upper case).

# For the "time" variable, you can use sinceTimePerod and
# lastTimePeriod to define a span.

dat2 <- get_eurostat(
  id = id, 
  filters = list(geo = c("EU28", "FI", "DE")),
  lastTimePeriod = 1,
  time_format = "num"
  )

knitr::kable(head(dat2))


## Replacing codes with labels ----

# By default, variables are returned as Eurostat codes,
# but to get human-readable labels instead, use a type = "label"
# argument.
datl2 <- get_eurostat(
  id = id,
  filters = list(
    geo = c("EU28", "FI", "DE"),
    lastTimePeriod = 1
  ),
  type = "label",
  time_format = "num"
)

knitr::kable(head(datl2))


# Eurostat codes in the downloaded data set can be replaced
# 2ith human-readable labels form the Eurostat dictionaries with the
# label_eurostat() function.
datl <- label_eurostat(dat)
knitr::kable(head(datl))

# The label_eurostat_vars() function allows the conversion of
# individual variable vectors or names as well.


## Selecting and modifying data for EFTA, Eurozone,
# EU, and EU candidate countries ----

# To eurostat package provides ready-made lists of the country
# codes used in the eurostat database:
# - efta_countries
# - ea_countries
# - eu_countries
# - eu_candidate_countries

# For conversion with other standard country coding systems,
# see the "countrycode" R package.

# To retrieve the country code list for EFTA, use:
data("efta_countries")
knitr::kable(efta_countries)
# Iceland, Liechtenstein, Norway, Switzerland

data("eu_candidate_countries")
knitr::kable(eu_candidate_countries)
# Montenegro, Moldova, North Macedonia, Albania, Serbia,
# Türkiye, Ukraine


## Eu data from 2012 in all vehicles
data_eu12 <- subset(x = datl, geo == "Germany" & time == 2012)
knitr::kable(data_eu12, row.names = FALSE)


## SDMX ----

# Eurostat data is also available in the Statistical Data and
# Metadata eXchange (SDMX) Web Services.

# Use the restapi, rsdmx, or rjsdmx packages to access data
# from SDMX.

citation("eurostat")
sessionInfo()

# END