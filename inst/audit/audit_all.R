

stamp <- format(Sys.time(), "%Y-%m-%d_%H-%M")

audit_evt <- "inst/audit/audit_evt.R"
evt_out_name <- paste0(stamp, "_audit_evt.md")

rmarkdown::render(
  audit_evt,
  output_format = "github_document",
  output_file = evt_out_name,
  envir = new.env())
