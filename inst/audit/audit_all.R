

# stamp <- format(Sys.time(), "%Y-%m-%d_%H-%M")

audit_evt <- "inst/audit/audit_evt.R"
evt_out_name <- "audit-evt.md"

audit_ppvt <- "inst/audit/audit_ppvt.R"
ppvt_out_name <- "audit-ppvt.md"

rmarkdown::render(
  audit_evt,
  output_format = "github_document",
  output_file = evt_out_name,
  envir = new.env())

rmarkdown::render(
  audit_ppvt,
  output_format = "github_document",
  output_file = ppvt_out_name,
  envir = new.env())

