% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/write_csv.R
\name{write_csv}
\alias{write_csv}
\title{Export to csv file}
\usage{
write_csv(df, file = NULL)
}
\arguments{
\item{df}{A survey dataset.}

\item{file}{A file name.}
}
\value{
The df with declared variables mutated into two columns.
}
\description{
Export the survey to csv in a way that declared variables
have numeric and character representation in the exported file.
}
\examples{
sample_data <- read_sav_gesis(
  file = system.file("extdata", "ZA5933_sample.sav",
                     package = "eurobarometer"))
write_csv(sample_data, file = file.path(tempdir(), "sample.csv"))
read.csv(file = file.path(tempdir(), "sample.csv"))
}
