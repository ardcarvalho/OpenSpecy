% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/match_spec.R
\name{match_spec}
\alias{match_spec}
\alias{match_spec.formula}
\alias{match_spec.data.frame}
\alias{match_spec.default}
\alias{find_spec}
\title{Match spectra with reference library}
\usage{
match_spec(x, ...)

\method{match_spec}{formula}(formula, data = NULL, ...)

\method{match_spec}{data.frame}(x, ...)

\method{match_spec}{default}(
  x,
  y,
  library,
  which = NULL,
  type = "full",
  range = seq(0, 6000, 0.1),
  top_n = 100,
  ...
)

find_spec(
  subset,
  library,
  which = NULL,
  type = "metadata",
  cols = c("spectrum_identity", "organization", "contact_info", "spectrum_type",
    "instrument_used", "instrument_accessories", "instrument_mode", "laser_light_used",
    "total_acquisition_time_s", "number_of_accumulations",
    "level_of_confidence_in_identification", "cas_number", "material_producer",
    "material_purity", "material_form", "material_quality", "spectral_resolution",
    "data_processing_procedure", "other_information", "sample_name", "wavenumber",
    "intensity", "group"),
  ...
)
}
\arguments{
\item{x}{a numeric vector containing the spectral wavenumbers; alternatively
a data frame containing spectral data as \code{"wavenumber"} and
\code{"intensity"} can be supplied.}

\item{formula}{an object of class '\code{\link[stats]{formula}}' of the form
\code{intensity ~ wavenumber}.}

\item{data}{a data frame containing the variables in \code{formula}.}

\item{y}{a numeric vector containing the spectral intensities.}

\item{library}{reference library you want to compare against.}

\item{which}{a character string specifying which library to match,
\code{"raman"} or \code{"ftir"}.}

\item{type}{a character string specifying whether the \code{"full"} spectrum
should be matched or spectrum \code{"peaks"} only. \code{"metadata"} is
needed to browser spectra with \code{find_spec()}.}

\item{range}{this should be all possible wavenumber values from your spectral
library.}

\item{top_n}{number of top matches that you want to be returned.}

\item{subset}{logical expression indicating elements or rows to search for;
see \code{\link[base]{subset}()} for details.}

\item{cols}{columns to retrieve from the Open Specy reference library;
columns containing no or missing values are automatically removed.}

\item{\ldots}{further arguments passed to the submethods.}
}
\value{
\code{match_spec()} returns a data frame with the \code{top_n} material
matches, their Pearson's r value, and the organization they were provided by.
\code{find_spec()} returns a data frame with the spectral raw data or
metadata of a specific reference spectrum.
}
\description{
\code{match_spec()} will compare a spectrum to a spectral library formatted
with the Open Specy standard and report the best match using the Pearson
correlation coefficient.
\code{find_spec()} makes it easy to retrieve single spectra and metadata
from the Open Specy reference library.
}
\details{
This routine will match the spectrum you want to identify to the wavenumbers
present in the spectral library. Once the spectra are aligned, it computes
the Pearson correlation coefficient between the spectrum you want to
identify and all spectra in the library (see \code{\link[stats]{cor}}).
The function returns a table with the Pearson correlation coefficient values
and all metadata for the top spectral matches.
If using the Open Specy library, all intensity values are in absorbance, so
your spectra should also be in absorbance units. If you need to convert your
spectrum, use \code{\link{adj_intens}()}.
}
\examples{
\dontrun{
data("raman_hdpe")

get_lib("raman")
spec_lib <- load_lib("raman")

match_spec(raman_proc, library = spec_lib, which = "raman")

find_spec(sample_name == 5381, library = spec_lib, which = "raman")
}

}
\seealso{
\code{\link{adj_intens}()} converts spectra;
\code{\link{get_lib}()} retrieves the Open Specy reference library;
\code{\link{load_lib}()} loads the Open Specy reference library into an \R
object of choice
}
\author{
Win Cowger, Zacharias Steinmetz
}
