# Eurostat

This repository contains code that illustrates how to access codes from [Eurostat](https://ec.europa.eu/eurostat), using the [eurostat](https://cran.r-project.org/package=eurostat) package.

You can learn more about the package on its [website](https://ropengov.github.io/eurostat/).

Data sets are downloaded from the [Eurostat bulk download facility](https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing) or from [The Eurostat Web Services JSON API](https://ec.europa.eu/eurostat/web/main/data/web-services).

The bulk download facility is the fastest method to download whole datasets. It is also often the only way as the JSON API has limitation of maximum 50 sub-indicators at time and whole datasets usually exceeds that. lso, it seems that multi frequency datasets can only be retrieved via bulk download facility.

If your connection is thru a proxy, you probably have to set proxy parameters to use JSON API, see `get_eurostat_json()`.

By default datasets from the bulk download facility are cached as they are often rather large. Caching is not (currently) possible for datasets from JSON API. Cache files are stored in a temporary directory by default or in a named directory (See `set_eurostat_cache_dir()`). The cache can be emptied with `clean_eurostat_cache()`.

The id, a code, for the dataset can be searched with the `search_eurostat()` or from the Eurostat database https://ec.europa.eu/eurostat/data/database. The Eurostat database gives codes in the Data Navigation Tree after every dataset in parenthesis.