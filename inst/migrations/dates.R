# Load and reduce all the DIRT spreadsheets
library("stringr")
library("readxl")
library("dplyr")
library("tidyr")

# get all the date data from a single directory of data spreadsheets
collect_dates <- function(date_dir, pattern = "TimePoint.Dates", recursive = FALSE) {
  # get the full path of each spreadsheet
  date_spreadsheets <- date_dir %>%
    list.files(pattern = pattern, full.names = TRUE, recursive = recursive) %>%
    normalizePath(mustWork = TRUE)

  # get the contents of each spreadsheet in large dataframe
  all_dates <- date_spreadsheets %>%
    lapply(get_date_spreadsheet) %>%
    bind_rows
  all_dates
}

# load a data spreadsheet and return in a long-format dataframe
get_date_spreadsheet <- function(file_path) {
  # used to differentiate the spreadsheets
  site <- file_path %>% basename %>% str_extract("UW|UMN")
  timepoint <- file_path %>% basename %>% str_extract("TimePoint\\d")

  # load and convert to long format so all spreadsheets have the same columns
  contents <- read_excel(file_path, na = "NA") %>%
    gather(Variable, Value, -ParticipantID) %>%
    mutate(Site = site, Study = timepoint) %>%
    select(Site, Study, ParticipantID, Variable, Value)
  contents
}
