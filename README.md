
<!-- README.md is generated from README.Rmd. Please edit that file -->

# eurobarometer

<!-- badges: start -->

[![dataobservatory on
Github](https://img.shields.io/badge/github-dataobservatory.eu-6e5494.svg)](https://github.com/dataobservatory-eu/)
[![R package
retroharmonize](https://img.shields.io/badge/R-retroharmonize-007CBB.svg)](https://iotables.dataobservatory.eu)
[![R package
dataset](https://img.shields.io/badge/R-dataset-E4007F.svg)](https://dataset.dataobservatory.eu)
[![Contributor
Covenant](https://img.shields.io/badge/ethics-Contributor%20Covenant-680171.svg)](https://dataobservatory.eu/)
[![Project Status: Active. The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![license](https://img.shields.io/badge/license-GPL--3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)
\[ <!-- badges: end -->

The goal of eurobarometer is to provide helper functions for the use of
the [retroharmonize](https://retroharmonize.dataobservatory.eu/) package
when working with SPSS versions of the Eurobarometer surveys files that
are stored at GESIS. This package was not made, and is not affiliated
with GESIS.

## Installation

You can install the development version of eurobarometer from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("dataobservatory-eu/eurobarometer")
```

## Work with GESIS survey datasets

The `read_sav_gesis()` function is a wrapper with
[haven::read_sav](https://haven.tidyverse.org/reference/read_spss.html)
with the following modifications:

``` r
library(eurobarometer)
ZA5933 <- read_sav_gesis(file = system.file("extdata", "ZA5933_sample.sav", 
                                            package = "eurobarometer"))
```

-   The original, labelled survey variables are stored as `declared`,
    which has many advantages compared to the labelled class used by
    haven.
-   The study-level metadata is added as metadata to the data.frame with
    [dataset::dublincore_add](https://dataset.dataobservatory.eu/reference/dublincore.html).
-   A truly unique identifier is added to the dataset. GESIS’s `uniqid`
    identifier is designed to be unique within one *wave* of
    Eurobarometer surveys. To avoid identification duplication,
    retroharmonize adds an `id` to each row.

## Advantages of declared

The use of declared makes type conversions (and recoding, relabelling)
easier.

``` r
ZA5933_sample$d25_num
#>  [1] 3 3 1 1 2 1 3 1 2 1 1 1
ZA5933_sample$d25_chr
#>  [1] "Large town"                 "Large town"                
#>  [3] "Rural area or village"      "Rural area or village"     
#>  [5] "Small or middle sized town" "Rural area or village"     
#>  [7] "Large town"                 "Rural area or village"     
#>  [9] "Small or middle sized town" "Rural area or village"     
#> [11] "Rural area or village"      "Rural area or village"
```

## Advantages of dataset

The use of `dataset` helps to retain dataset-level metadata, which is
critically important when we will combine datasets of different
Eurobarometer survey waves, or make other interventions in the various
stages of the survey lifecycle.

``` r
library(dataset)
attr(ZA5933_sample, "Title")
#>                                         Title titleType
#> 1 Eurobarometer 82.4 (November-December 2014)     Title
dataset::identifier(ZA5933_sample)
#> [1] "doi:10.4232/1.13044"
dataset::publisher(ZA5933_sample)
#> [1] "GESIS"
```

\`\`\`
