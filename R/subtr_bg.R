#' @title Automated background subtraction for spectral data
#'
#' @description
#' This baseline correction routine iteratively finds the baseline of a spectrum
#' using a polynomial fitting.
#'
#' @details
#' This is a translation of Michael Stephen Chen's MATLAB code written for the
#' \code{imodpolyfit} routine from Zhao et al. 2007.
#'
#' @param x a numeric vector containing the spectral wavenumbers; alternatively
#' a data frame containing spectral data as \code{"wavenumber"} and
#' \code{"intensity"} can be supplied.
#' @param y a numeric vector containing the spectral intensities.
#' @param formula an object of class '\code{\link[stats]{formula}}' of the form
#' \code{intensity ~ wavenumber}.
#' @param data a data frame containing the variables in \code{formula}.
#' @param degree the degree of the polynomial. Must be less than the number of
#' unique points when raw is \code{FALSE}. Typically a good fit can be
#' found with a 8th order polynomial.
#' @param raw if \code{TRUE}, use raw and not orthogonal polynomials.
#' @param make_rel logical; if \code{TRUE} spectra are automatically normalized
#' with \code{\link{make_rel}()}.
#' @param \ldots further arguments passed to \code{\link[stats]{poly}()}.
#'
#' @return
#' \code{subtr_bg()} returns a data frame containing two columns named
#' \code{"wavenumber"} and \code{"intensity"}.
#'
#' @examples
#' data("raman_hdpe")
#'
#' subtr_bg(raman_hdpe)
#'
#' @author
#' Win Cowger, Zacharias Steinmetz
#'
#' @seealso
#' \code{\link[stats]{poly}()};
#' \code{\link{smooth_intens}()}
#'
#' @references
#' Chen MS (2020). Michaelstchen/ModPolyFit. \emph{MATLAB}.
#' Retrieved from \url{https://github.com/michaelstchen/modPolyFit}
#' (Original work published July 28, 2015)
#'
#' Zhao J, Lui H, McLean DI, Zeng H (2007). “Automated Autofluorescence
#' Background Subtraction Algorithm for Biomedical Raman Spectroscopy.”
#' \emph{Applied Spectroscopy}, \strong{61}(11), 1225–1232.
#' \doi{10.1366/000370207782597003}.
#'
#' @importFrom dplyr %>%
#' @importFrom stats terms model.frame sd lm poly approx
#' @export
subtr_bg <- function(x, ...) {
  UseMethod("subtr_bg")
}

#' @rdname subtr_bg
#'
#' @export
subtr_bg.formula <- function(formula, data = NULL, ...) {
  if (missing(formula) || (length(formula) != 3L) ||
      (length(attr(terms(formula[-2L]), "term.labels")) != 1L))
    stop("'formula' missing or incorrect")

  mf <- model.frame(formula, data)
  lst <- as.list(mf)
  names(lst) <- c("y", "x")

  do.call("subtr_bg", c(lst, list(...)))
}

#' @rdname subtr_bg
#'
#' @export
subtr_bg.data.frame <- function(x, ...) {
  if (!all(c("wavenumber", "intensity") %in% names(x)))
    stop("'data' must contain 2 columns named 'wavenumber' and 'intensity'")

  do.call("subtr_bg", list(x$wavenumber, x$intensity, ...))
}

#' @rdname subtr_bg
#'
#' @export
subtr_bg.default <- function(x, y, degree = 8, raw = FALSE,
                             make_rel = TRUE, ...) {
  xin <- x
  yin <- y
  dev_prev <- 0 # standard deviation residuals for the last iteration of polyfit;
  # set initially to 0
  first_iter <- TRUE
  criteria_met <- FALSE

  while (!criteria_met) {
    # Predict the intensity using the polynomial of specified length
    paramVector <- lm(y ~ stats::poly(x, degree = degree, raw = raw, ...))

    residual <- paramVector$residuals

    mod_poly <- paramVector$fitted.values

    dev_curr <- sd(residual)

    # Remove peaks
    if (first_iter) {
      peaks <- c()
      for (i in 1:length(y)) {
        if (y[i] > mod_poly[i] + dev_curr) {
          peaks <- c(peaks,i)
        }
      }
      y <- y[-peaks]
      mod_poly <- mod_poly[-peaks]
      x <- x[-peaks]
      first_iter <- FALSE
    }

    # Replace data with lower value if polynomial is lower
    for (j in 1:length(y)) {
      if (mod_poly[j] + dev_curr > y[j]) {
        y[j] <- y[j]
      } else {
        y[j] <- mod_poly[j]
      }
    }

    # Test criteria
    criteria_met <- abs((dev_curr - dev_prev) / dev_curr) <= 0.05

    # Approximate the intensity back to the original wavelengths, allows below
    # the peak to be interpolated
    if(criteria_met) {
      ysbg <- approx(x, y, xout = xin, rule = 2, method = "linear",
                     ties = mean)[2] %>%
        unlist() %>%
        unname()

      if (make_rel) yout <- make_rel(yin - ysbg) else
        yout <- yin - ysbg

      return(data.frame(wavenumber = xin, intensity = yout))
    }

    # Update previous residual metric
    dev_prev <- dev_curr
  }
}
