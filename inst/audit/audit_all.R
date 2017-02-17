
audit_ppvt <- rprojroot::find_rstudio_root_file("inst/audit/audit_ppvt.R")

ppvt_out_name <- "audit_ppvt.md"

rmarkdown::render(
  audit_ppvt,
  output_format = "github_document",
  output_file = ppvt_out_name,
  envir = new.env())
