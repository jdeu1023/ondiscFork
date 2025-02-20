% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/s4_get_basic_info_methods.R
\name{get-names}
\alias{get-names}
\alias{get_feature_ids}
\alias{get_feature_names}
\alias{get_cell_barcodes}
\alias{get_feature_ids,ondisc_matrix-method}
\alias{get_feature_names,ondisc_matrix-method}
\alias{get_cell_barcodes,ondisc_matrix-method}
\alias{get_feature_ids,covariate_ondisc_matrix-method}
\alias{get_feature_names,covariate_ondisc_matrix-method}
\alias{get_cell_barcodes,covariate_ondisc_matrix-method}
\alias{get_feature_ids,multimodal_ondisc_matrix-method}
\alias{get_feature_names,multimodal_ondisc_matrix-method}
\alias{get_cell_barcodes,multimodal_ondisc_matrix-method}
\title{Get cell barcodes, feature names, and feature IDs.}
\usage{
get_feature_ids(x)

get_feature_names(x)

get_cell_barcodes(x)

\S4method{get_feature_ids}{ondisc_matrix}(x)

\S4method{get_feature_names}{ondisc_matrix}(x)

\S4method{get_cell_barcodes}{ondisc_matrix}(x)

\S4method{get_feature_ids}{covariate_ondisc_matrix}(x)

\S4method{get_feature_names}{covariate_ondisc_matrix}(x)

\S4method{get_cell_barcodes}{covariate_ondisc_matrix}(x)

\S4method{get_feature_ids}{multimodal_ondisc_matrix}(x)

\S4method{get_feature_names}{multimodal_ondisc_matrix}(x)

\S4method{get_cell_barcodes}{multimodal_ondisc_matrix}(x)
}
\arguments{
\item{x}{an object of class \code{ondisc_matrix}, \code{covariate_ondisc_matrix}, or \code{multimodal_ondisc_matrix}.}
}
\value{
A character vector or list of character vectors containing the requested identifiers.
}
\description{
Obtain cell barcodes, feature names, and feature IDs of an \code{ondisc_matrix}, \code{covariate_ondisc_matrix},
or \code{multimodal_ondisc_matrix}.
}
\details{
The following functions can be used to obtain feature and cell identifiers:
\itemize{
\item \code{get_cell_barcodes}: return the cell barcodes.
\item \code{get_feature_names}: return the feature names.
\item \code{get_feature_ids}: return the IDs of the features.
}

In general, these functions return a character vector containing the requested identifiers. When
\code{get_feature_names} or \code{get_feature_ids} is called on a \code{multimodal_ondisc_matrix}, the function instead
returns a list containing the feature names and feature IDs, respectively, of the modalities contained
within the \code{multimodal_ondisc_matrix}.
}
\examples{
# Install the `ondiscdata` package to run the examples.
# devtools::install_github("timothy-barry/ondiscdata")

####################################
# EXAMPLE 1: covariate_ondisc_matrix
####################################
# Load odm from package
odm_fp <- system.file("extdata", "odm/gene/matrix.odm", package = "ondiscdata")
metadata_fp <- system.file("extdata", "odm/gene/metadata.rds", package = "ondiscdata")
odm <- read_odm(odm_fp, metadata_fp)
feature_ids <- get_feature_ids(odm)
feature_names <- get_feature_names(odm)
cell_barcodes <- get_cell_barcodes(odm)

#####################################
# EXAMPLE 2: multimodal_ondisc_matrix
#####################################
# Load odm from package
odm_gene_fp <- system.file("extdata", "odm/gene/matrix.odm", package = "ondiscdata")
metadata_gene_fp <- system.file("extdata", "odm/gene/metadata.rds", package = "ondiscdata")
odm_gene <- read_odm(odm_gene_fp, metadata_gene_fp)
odm_grna_fp <- system.file("extdata",
"odm/grna_assignment/matrix.odm", package = "ondiscdata")
metadata_grna_fp <- system.file("extdata",
"odm/grna_assignment/metadata.rds", package = "ondiscdata")
odm_grna <- read_odm(odm_grna_fp, metadata_grna_fp)

odm_multi <- multimodal_ondisc_matrix(list(gene = odm_gene, grna = odm_grna))
feature_ids <- get_feature_ids(odm_multi)
feature_names <- get_feature_names(odm_multi)
cell_barcodes <- get_cell_barcodes(odm_multi)
}
