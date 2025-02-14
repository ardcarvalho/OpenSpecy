data("raman_hdpe")

test_that("subtr_bg() works as expected", {
  expect_silent(sb <- subtr_bg(raman_hdpe, degree = 8))
  expect_identical(sb, subtr_bg(raman_hdpe$wavenumber,
                                raman_hdpe$intensity))
  expect_identical(sb, subtr_bg(intensity ~ wavenumber, raman_hdpe))
  expect_equal(as.numeric(
    round(cor(sb[2], subtr_bg(raman_hdpe, degree = 1)[2]), 4)
  ), 0.9763, ignore_attr = F)
  expect_s3_class(sb, "data.frame")
  expect_equal(names(sb), c("wavenumber", "intensity"))
  expect_equal(nrow(sb), nrow(raman_hdpe))
  expect_equal(sb[1], raman_hdpe[1])
  expect_equal(range(sb[2]), c(0, 1))
})
