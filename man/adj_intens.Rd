% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/adj_intens.R
\name{adj_intens}
\alias{adj_intens}
\alias{adj_intens.formula}
\alias{adj_intens.data.frame}
\alias{adj_intens.default}
\title{Adjust spectral intensities to absorbance units}
\usage{
adj_intens(x, ...)

\method{adj_intens}{formula}(formula, data = NULL, ...)

\method{adj_intens}{data.frame}(x, ...)

\method{adj_intens}{default}(x, y, type = "none", make_rel = TRUE, ...)
}
\arguments{
\item{x}{a numeric vector containing the spectral wavenumbers; alternatively
a data frame containing spectral data as \code{"wavenumber"} and
\code{"intensity"} can be supplied.}

\item{formula}{an object of class '\code{\link[stats]{formula}}' of the form
\code{intensity ~ wavenumber}.}

\item{data}{a data frame containing the variables in \code{formula}.}

\item{y}{a numeric vector containing the spectral intensities.}

\item{type}{a character string specifying whether the input spectrum is
in absorbance units (\code{"none"}, default) or needs additional conversion
from \code{"reflectance"} or \code{"transmittance"} data.}

\item{make_rel}{logical; if \code{TRUE} spectra are automatically normalized
with \code{\link{make_rel}()}.}

\item{\ldots}{further arguments passed to the submethods.}
}
\value{
\code{adj_intens()} returns a data frame containing two columns
named \code{"wavenumber"} and \code{"intensity"}.
}
\description{
Converts reflectance or transmittance intensity units to absorbance units.
}
\details{
Many of the Open Specy functions will assume that the spectrum is in
absorbance units. For example, see \code{\link{match_spec}()} and
\code{\link{subtr_bg}()}.
To run those functions properly, you will need to first convert any spectra
from transmittance or reflectance to absorbance using this function.
The transmittance adjustment uses the \eqn{log10(1 / T)}
calculation which does not correct for system and particle characteristics.
The reflectance adjustment uses the Kubelka-Munk equation
\eqn{(1 - R)^2 / 2R}. We assume that the reflectance intensity
is a percent from 1-100 and first correct the intensity by dividing by 100
so that it fits the form expected by the equation.
}
\examples{
data("raman_hdpe")

adj_intens(raman_hdpe)

}
\seealso{
\code{\link{subtr_bg}()} for spectral background correction;
\code{\link{match_spec}()} matches spectra with the Open Specy or other
reference libraries
}
\author{
Win Cowger, Zacharias Steinmetz
}
