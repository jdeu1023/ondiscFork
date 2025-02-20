% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/s4_classes.R
\name{ondisc_matrix}
\alias{ondisc_matrix}
\title{\code{ondisc_matrix} class}
\usage{
ondisc_matrix(
  h5_file = NA_character_,
  logical_mat = FALSE,
  underlying_dimension = NA_integer_,
  cell_subset = NA_integer_,
  feature_subset = NA_integer_,
  feature_ids = NA_character_,
  feature_names = NA_character_,
  cell_barcodes = NA_character_,
  odm_id = NA_integer_,
  feature_access_only = FALSE
)

ondisc_matrix(
  h5_file = NA_character_,
  logical_mat = FALSE,
  underlying_dimension = NA_integer_,
  cell_subset = NA_integer_,
  feature_subset = NA_integer_,
  feature_ids = NA_character_,
  feature_names = NA_character_,
  cell_barcodes = NA_character_,
  odm_id = NA_integer_,
  feature_access_only = FALSE
)
}
\arguments{
\item{h5_file}{location of backing .odm file on disk.}

\item{logical_mat}{boolean indicating whether matrix is logical}

\item{underlying_dimension}{dimension of underlying expression matrix}

\item{cell_subset}{integer vector indicating cells in use}

\item{feature_subset}{integet vector indicating features in use}

\item{feature_ids}{character vector of feature IDs}

\item{feature_names}{character vector of feature names}

\item{cell_barcodes}{character vector of cell barcodes}

\item{odm_id}{unique (with high probability) integer}

\item{feature_access_only}{logical indicating whether the matrix should provide access to features only (TRUE) or to both features and cells (FALSE)}
}
\value{
initialized \code{ondisc_matrix} object
}
\description{
An \code{ondisc_matrix} represents a feature-by-cell expression matrix stored on-disk.

Constructor function for \code{ondisc_matrix} class.
}
\details{
It is best to avoid interacting with the slots of an \code{ondisc_matrix} directly. Instead, use the functions
and operators provided by the package.
}
