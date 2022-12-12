
<!-- README.md is generated from README.Rmd. Please edit that file -->

# eurobarometer

<!-- badges: start -->

[![dataobservatory on
Github](https://img.shields.io/badge/github-dataobservatory.eu-6e5494.svg)](https://github.com/dataobservatory-eu/)
[![R package
retroharmonize](https://img.shields.io/badge/R-retroharmonize-007CBB.svg)](https://retroharmonize.dataobservatory.eu)
[![dataset](https://img.shields.io/badge/R-dataset-E4007F.svg)](https://dataset.dataobservatory.eu)
[![Contributor
Covenant](https://img.shields.io/badge/ethics-Contributor%20Covenant-680171.svg)](https://dataobservatory.eu/)
[![Project Status: Active. The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![license](https://img.shields.io/badge/license-GPL--3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/dataobservatory-eu/eurobarometer?branch=main&svg=true)](https://ci.appveyor.com/project/dataobservatory-eu/eurobarometer)
<!-- badges: end -->

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

You will also need similarly
`devtools::install_github("dataobservatory-eu/dataset")` (at least
version 0.1.9.0004) and the latest version of declared.

## Work with GESIS survey datasets

The `read_sav_gesis()` function is a wrapper with `DDIwR::convert()`
with the following modifications:

``` r
library(eurobarometer)
ZA5933 <- read_sav_gesis(file = system.file("extdata", "ZA5933_sample.sav", 
                                            package = "eurobarometer"))
```

-   The original, labelled survey variables are stored as
    [declared](https://declared.dataobservatory.eu/reference/declared.html),
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
#>  [1] 2 1 3 3 2 2 1 2 1 2 1 3
ZA5933_sample$d25_chr
#>  [1] "Small or middle sized town" "Rural area or village"     
#>  [3] "Large town"                 "Large town"                
#>  [5] "Small or middle sized town" "Small or middle sized town"
#>  [7] "Rural area or village"      "Small or middle sized town"
#>  [9] "Rural area or village"      "Small or middle sized town"
#> [11] "Rural area or village"      "Large town"
```

## Advantages of dataset

The use of `dataset` helps to retain dataset-level metadata, which is
critically important when we will combine datasets of different
Eurobarometer survey waves, or make other interventions in the various
stages of the survey lifecycle.

``` r
library(dataset)
ZA5933_sample
#> Eurobarometer 82.4 (November-December 2014) (subset) (subset) [doi:10.4232/1.13044] 
#> Published by GESIS
#>                 id   uniqid d25 d25_num                    d25_chr
#> 1  za5933_46001088 46001088   2       2 Small or middle sized town
#> 2  za5933_42000703 42000703   1       1      Rural area or village
#> 3  za5933_32000989 32000989   3       3                 Large town
#> 4  za5933_12001054 12001054   3       3                 Large town
#> 5  za5933_35000877 35000877   2       2 Small or middle sized town
#> 6  za5933_40002682 40002682   2       2 Small or middle sized town
#> 7   za5933_7001327  7001327   1       1      Rural area or village
#> 8  za5933_36003657 36003657   2       2 Small or middle sized town
#> 9  za5933_35001629 35001629   1       1      Rural area or village
#> 10 za5933_22086838 22086838   2       2 Small or middle sized town
#> 
#> ... 2 further observations.
```

``` r
attributes(ZA5933_sample)
#> $names
#> [1] "id"      "uniqid"  "d25"     "d25_num" "d25_chr"
#> 
#> $row.names
#>  [1]  1  2  3  4  5  6  7  8  9 10 11 12
#> 
#> $class
#> [1] "dataset"    "data.frame"
#> 
#> $Title
#> $Title$Title
#> [1] "Eurobarometer 82.4 (November-December 2014) (subset) (subset)"
#> 
#> 
#> $Identifier
#> $Identifier$doi
#> [1] "doi:10.4232/1.13044"
#> 
#> 
#> $Publisher
#> [1] "GESIS"
#> 
#> $Type
#> $Type$resourceType
#> [1] "DCMITYPE:Dataset"
#> 
#> $Type$resourceTypeGeneral
#> [1] "Dataset"
#> 
#> 
#> $Description
#> [1] NA
#> 
#> $Size
#> [1] "7.01 kB [6.84 KiB]"
#> 
#> $Date
#> [1] "2022-12-12"
```
