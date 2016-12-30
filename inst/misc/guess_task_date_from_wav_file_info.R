# A helper script that guess the date a task occurred from a wav file's
# modification time. Not at all fool-proof, but a fast first approximation.

library(dplyr)
library(stringr)

list_wav_files_in_dir <- function(dir, pattern = ".(WAV|Wav|wav)") {
  list.files(dir, pattern, full.names = TRUE, recursive = TRUE)
}

extract_short_id <- function(xs) {
  xs %>% str_extract("\\d{3}\\w\\d{2}\\w{2}\\d") %>% str_extract("^\\d{3}\\w")
}

get_file_date <- function(xs) {
  xs %>% file.mtime() %>% as.Date %>% format()
}

extract_task <- function(xs) {
  task_names <- c("EVT", "GFTA", "LanguageSample", "NonWordRep", "MPNorm_OA",
                  "SAILS", "Blending", "MPNorm_OB", "Rhyming", "MPNorm_CA",
                  "MPNorm_CB", "RealWordRep", "CTOPPBlending", "CTOPPElision",
                  "DELVSyntax", "DELVDialect", "VerbalFluency",
                  "CTOPPMemForDigits", "MINP")
  task_pattern <- task_names %>% paste0(collapse = "|")
  tasks <- str_extract(xs, task_pattern)
  if (any(is.na(tasks))) {
    unknown_task <- xs[which(is.na(tasks))] %>% basename()
    file_list <- unknown_task %>% paste0(collapse = "\n  ")
    warning("Unknown task in file: \n  ", file_list, call. = FALSE)
  }
  tasks
}

extract_study <- function(xs) {
  xs <- xs %>% str_extract("CochlearV\\d|TimePoint\\d")
  xs[is.na(xs)] <- "no study"
  xs
}

get_recording_dates <- function(folder) {
  recordings <- list_wav_files_in_dir(folder)

  task_dates <- data_frame(File = recordings) %>%
    mutate(
      Study = extract_study(File),
      ID = extract_short_id(File),
      Task = extract_task(File),
      TaskDate = get_file_date(File),
      Date = paste0("'", TaskDate))

  task_dates$Task <- task_dates$Task %>%
    str_replace("DELVDialect", "DELV") %>%
    str_replace("CTOPPMemForDigits", "CTOPPMemory")

  task_dates %>%
    select(Study, Task, ID, Date) %>%
    tidyr::gather(Variable, Value,  -Task, -ID, -Study) %>%
    filter(Task != "RealWordRep", Task != "NonWordRep") %>%
    tidyr::unite(TaskDate, Task, Variable) %>%
    # Number separate entries when there is more than one recording
    group_by(Study, ID, TaskDate) %>%
    mutate(TaskDate2 = paste0(TaskDate, seq_after_first(TaskDate))) %>%
    ungroup() %>%
    select(-TaskDate) %>%
    rename(TaskDate = TaskDate2) %>%
    tidyr::spread(TaskDate, Value) %>%
    arrange(Study, ID)
}

seq_after_first <- function(xs) {
  this_seq <- seq_along(xs)
  if (0 < length(this_seq)) {
    this_seq[1] <- ""
  }
  this_seq
}

preview_in_excel <- function(df) {
  out <- tempfile(fileext = ".csv")
  readr::write_csv(df, out)
  shell(sprintf("open %s", out))
  invisible(df)
}

# UMN - single cross-sectional study
folder <- "SET FOLDER"
df <- get_recording_dates(folder)
preview_in_excel(df)

# UMN - many participant folders
base_folder <- "SET FOLDER"
# Use this regex so that folders like `Excluded_001L` don't get picked
participated <- list.files(base_folder, "^\\d{3}L")
folders <- file.path(base_folder, participated)

library(purrr)

df <- folders %>%
  map(safely(get_recording_dates))

umn_df <- df %>% map_df("result")

# View only rows used in participant info spreadsheet. source() code in head of
# EVT migration script first.
tp2 <- get_study_info("TimePoint2")

umn_tp2_kids <- tp2$UMN %>%
  select(ID = Participant_ID) %>%
  mutate(Study = "TimePoint2")

umn_df %>%
  right_join(umn_tp2_kids) %>%
  arrange(Study, ID) %>%
  preview_in_excel()

