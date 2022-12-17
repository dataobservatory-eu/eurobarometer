
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

Currently `eurobarometer` can be seen as a development version of the
[retroharmonize](https://retroharmonize.dataobservatory.eu/) pacakge.
Some important functions of retroharmonized are being modernized with
new dependencies: a new questionbank,
[DDIwR](https://eurobarometer.dataobservatory.eu/articles/dependencies.html),
[dataset](https://dataset.dataobservatory.eu/) and
[declared](https://declared.dataobservatory.eu/). After thorough
testing, most of these functions will be moved back to *retroharmonize*.
Eurobarometer will remain a helper package to use *retroharmonize* with
Eurobarometer surveys. It will serve as a template for similar works
with other survey programs, for example, *Afrobarometer*.

## Overview

-   [Articles](https://eurobarometer.dataobservatory.eu/articles/index.html)
    on the package website.
-   [Function
    reference](https://eurobarometer.dataobservatory.eu/docs/reference/index.html).

## Installation

Because `eurobarometer` is in an early development phase, you cannot
install it from CRAN with the `install.packages("eurobarometer")`
command yet. You can install the development version of `eurobarometer`
from [GitHub](https://github.com/dataobservatory-eu/eurobarometer) with
`devtools`. If you have not used devtools yet, please refer to the
[Installation
Guide](https://eurobarometer.dataobservatory.eu/articles/installation.html)
vignette:

``` r
# install.packages("devtools")
devtools::install_github("dataobservatory-eu/eurobarometer")
```

## Import Surveys

The `read_sav_gesis()` function is a wrapper with `DDIwR::convert()`
with the following modifications:

``` r
library(eurobarometer)
ZA5933 <- read_sav_gesis(file = system.file("extdata", "ZA5933_sample.sav", 
                                            package = "eurobarometer"))
```

## Work with Codebooks

``` r
codebook_create(ZA5933[, c("d25", "d60")], 
                val_labels = TRUE, 
                freq = TRUE)
#> Codebook for Eurobarometer 82.4 (November-December 2014) (subset) [10.4232/1.13044] 
#>            survey var_name_orig                        var_label_orig
#> 1 10.4232/1.13044           d25                     TYPE OF COMMUNITY
#> 2 10.4232/1.13044           d25                     TYPE OF COMMUNITY
#> 3 10.4232/1.13044           d25                     TYPE OF COMMUNITY
#> 4 10.4232/1.13044           d25                     TYPE OF COMMUNITY
#> 5 10.4232/1.13044           d60 DIFFICULTIES PAYING BILLS - LAST YEAR
#> 6 10.4232/1.13044           d60 DIFFICULTIES PAYING BILLS - LAST YEAR
#> 7 10.4232/1.13044           d60 DIFFICULTIES PAYING BILLS - LAST YEAR
#> 8 10.4232/1.13044           d60 DIFFICULTIES PAYING BILLS - LAST YEAR
#>   val_code_orig             val_label_orig
#> 1             1      Rural area or village
#> 2             2 Small or middle sized town
#> 3             3                 Large town
#> 4             8                         DK
#> 5             1           Most of the time
#> 6             2          From time to time
#> 7             3         Almost never/never
#> 8             7           Refusal (SPONT.)
```

For further details, see [Codebooks with
retroharmonize](https://eurobarometer.dataobservatory.eu/articles/codebook.html)
and [Eurobarometer Question Bank & Basic Code
Table](https://eurobarometer.dataobservatory.eu/articles/questionbank.html)
vignettes.

## Harmonization with Crosswalk Tables

For further details, see [Harmonize Surveys with Crosswalk
Tables](https://eurobarometer.dataobservatory.eu/articles/crosswalk.html)
vignette.

## Archivation

For further details, see [DDI Codebooks with
DDIwR](https://eurobarometer.dataobservatory.eu/articles/DDIwR.html)
vignette.

## Reviewability & Unit Testing

The human peer-review of output from many surveys is very difficult due
to the high dimensionality of the harmonized survey datasets. We would
like to support review with several forms of unit testing and
automation. See [Reviewability & Unit
Testing](https://eurobarometer.dataobservatory.eu/articles/testing.html)
for further details.

## Under the Hood

For further details, see [Dependencies: Other R packages
Used](https://eurobarometer.dataobservatory.eu/articles/dependencies.html)
vignette.
