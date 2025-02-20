# Class definition and methods for ondisc_matrix

##########################
# Classes and constructors
##########################

##################
# 1. ondisc_matrix
##################

#' `ondisc_matrix` class
#'
#' An `ondisc_matrix` represents a feature-by-cell expression matrix stored on-disk.
#'
#' It is best to avoid interacting with the slots of an `ondisc_matrix` directly. Instead, use the functions
#' and operators provided by the package.
ondisc_matrix <- setClass("ondisc_matrix",
                           slots = list(h5_file = "character",
                                        logical_mat = "logical",
                                        underlying_dimension = "integer",
                                        cell_subset = "integer",
                                        feature_subset = "integer",
                                        feature_ids = "character",
                                        feature_names = "character",
                                        cell_barcodes = "character",
                                        odm_id = "integer",
                                        feature_access_only = "logical"))


#' Instantiate an `ondisc_matrix` object
#'
#' Constructor function for `ondisc_matrix` class.
#'
#' @param h5_file location of backing .odm file on disk.
#' @param logical_mat boolean indicating whether matrix is logical
#' @param underlying_dimension dimension of underlying expression matrix
#' @param cell_subset integer vector indicating cells in use
#' @param feature_subset integet vector indicating features in use
#' @param feature_ids character vector of feature IDs
#' @param feature_names character vector of feature names
#' @param cell_barcodes character vector of cell barcodes
#' @param feature_access_only logical indicating whether the matrix should provide access to features only (TRUE) or to both features and cells (FALSE)
#' @param odm_id unique (with high probability) integer
#'
#' @return initialized `ondisc_matrix` object
ondisc_matrix <- function(h5_file = NA_character_, logical_mat = FALSE, underlying_dimension = NA_integer_, cell_subset = NA_integer_, feature_subset = NA_integer_, feature_ids = NA_character_, feature_names = NA_character_, cell_barcodes = NA_character_, odm_id = NA_integer_, feature_access_only = FALSE) {
  out <- new("ondisc_matrix")
  out@h5_file <- h5_file
  out@logical_mat <- logical_mat
  out@underlying_dimension <- underlying_dimension
  out@cell_subset <- cell_subset
  out@feature_subset <- feature_subset
  out@feature_ids <- feature_ids
  out@feature_names <- feature_names
  out@cell_barcodes <- cell_barcodes
  out@odm_id <- odm_id
  out@feature_access_only <- feature_access_only

  check_dup <- function(v) any(duplicated(v))
  if (check_dup(cell_barcodes)) warning("Cell barcodes contain duplicates.")
  if (check_dup(feature_ids)) warning("Feature IDs contain duplicates.")
  return(out)
}


############################
# 2. covariate_ondisc_matrix
############################

#' `covariate_ondisc_matrix` class
#'
#' A `covariate_ondisc_matrix` stores an `ondisc_matrix`, along with cell-specific and feature-specific covariate matrices.
#'
#' @slot ondisc_matrix an ondisc_matrix.
#' @slot cell_covariates a data frame of cell covariates.
#' @slot feature_covariates a data frame of feature covariates.
covariate_ondisc_matrix <- setClass("covariate_ondisc_matrix",
                          slots = list(ondisc_matrix = "ondisc_matrix",
                                       cell_covariates = "data.frame",
                                       feature_covariates = "data.frame",
                                       post_load_function_present = "logical",
                                       post_load_function = "function",
                                       misc = "list"))


#' `covariate_ondisc_matrix` constructor
#'
#' Construct a `covariate_ondisc_matrix` by passing an `ondisc_matrix`, along with its associated `cell_covariates` and `feature_covariates`.
#'
#' @param ondisc_matrix an `ondisc_matrix`.
#' @param cell_covariates a data frame storing the cell-specific covariates.
#' @param feature_covariates a data frame storing the feature-specific covariates.
#'
#' @return a `covariate_ondisc_matrix`.
#' @export
#' @examples
#' # Install the `ondiscdata` package to run the examples.
#' # devtools::install_github("timothy-barry/ondiscdata")
#'
#' # Load odm from package
#' odm_fp <- system.file("extdata", "odm/gene/matrix.odm", package = "ondiscdata")
#' metadata_fp <- system.file("extdata", "odm/gene/metadata.rds", package = "ondiscdata")
#' odm <- read_odm(odm_fp, metadata_fp)
#' odm_subset <- odm[1:10,]
#'
#' covariate_odm <- covariate_ondisc_matrix(ondisc_matrix = get_ondisc_matrix(odm_subset),
#'                                          cell_covariates = get_cell_covariates(odm_subset),
#'                                          feature_covariates = get_feature_covariates(odm_subset))
covariate_ondisc_matrix <- function(ondisc_matrix, cell_covariates, feature_covariates) {
  out <- new("covariate_ondisc_matrix")
  out@ondisc_matrix <- ondisc_matrix
  row.names(cell_covariates) <- get_cell_barcodes(ondisc_matrix)
  row.names(feature_covariates) <- get_feature_ids(ondisc_matrix)
  out@cell_covariates <- cell_covariates
  out@feature_covariates <- feature_covariates
  out@post_load_function_present <- FALSE
  return(out)
}


#############################
# 3. multimodal_ondisc_matrix
#############################

setClassUnion("df_matrix", c("data.frame", "matrix"))

#' `multimodal_ondisc_matrix` class
#'
#' A `multimodal_ondisc_matrix` represents multimodal data.
#'
#' @slot modalities a list containing `covariate_ondisc_matrix` objects representing different modalities.
#' @slot global_cell_covariates a data frame containing the cell-specific covariates pooled across all modalities.
multimodal_ondisc_matrix <- setClass("multimodal_ondisc_matrix", slots = list(modalities = "list",
                                                                              global_cell_covariates = "df_matrix",
                                                                              global_misc = "list"))

#' `multimodal_ondisc_matrix` constructor
#'
#' Construct a `multimodal_ondisc_matrix` from a list of `covariate_ondisc_matrix` objects.
#'
#' @param covariate_ondisc_matrix_list a named list containing `covariate_ondisc_matrix` objects; the names are taken to be the names of the modalities.
#'
#' @return a multimodal_ondisc_matrix
#' @export
#' @examples
#' # Install the `ondiscdata` package to run the examples.
#' # devtools::install_github("timothy-barry/ondiscdata")
#'
#' # Load odm from package
#' odm_gene_fp <- system.file("extdata", "odm/gene/matrix.odm", package = "ondiscdata")
#' metadata_gene_fp <- system.file("extdata", "odm/gene/metadata.rds", package = "ondiscdata")
#' odm_gene <- read_odm(odm_gene_fp, metadata_gene_fp)
#' odm_grna_fp <- system.file("extdata",
#' "odm/grna_assignment/matrix.odm", package = "ondiscdata")
#' metadata_grna_fp <- system.file("extdata",
#' "odm/grna_assignment/metadata.rds", package = "ondiscdata")
#' odm_grna <- read_odm(odm_grna_fp, metadata_grna_fp)
#'
#' odm_multi <- multimodal_ondisc_matrix(list(gene = odm_gene, grna = odm_grna))
multimodal_ondisc_matrix <- function(covariate_ondisc_matrix_list) {
  # check that cell barcodes coincide across modalities
  barcodes_list <- lapply(covariate_ondisc_matrix_list, get_cell_barcodes)
  for (i in seq(2L, length(barcodes_list))) {
    if (!identical(barcodes_list[[1]], barcodes_list[[i]])) {
      warning("Cell barcodes are not identical across modalities.")
      break()
    }
  }
  out <- new(Class = "multimodal_ondisc_matrix")
  out@modalities <- covariate_ondisc_matrix_list
  df_list <- lapply(X = covariate_ondisc_matrix_list,
                    FUN = function(cov_odm) cov_odm@cell_covariates)
  modality_names <- names(covariate_ondisc_matrix_list)
  global_df <- combine_multimodal_dataframes(df_list, modality_names)
  out@global_cell_covariates <- global_df
  out@global_misc <- list()
  return(out)
}
