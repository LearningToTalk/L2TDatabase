# devtools::install_github("tjmahr/textgrid")
library("textgrid")
library("stringr")
library("dplyr")
library("tidyr")




# get participant id substring
extract_pid <- function(paths) {
  # Define the sub-parts of a participant id
  digit <- function(n) sprintf("\\d{%s}", n)
  char_set <- function(...) sprintf("[%s]", paste0(..., collapse = ""))
  id_parts <- c(
    ID = digit(3),
    Study = char_set("[:upper:]"),
    Age = digit(2),
    # Permit X for Gender or Dialect because TJM uses X in anonymized test files
    Gender = char_set("MFX"),
    Dialect = char_set("SAX"),
    Cohort = digit(1)
  )
  # Combine to create the full pattern for a participant ID
  id_pattern <- paste0(id_parts, collapse = "")

  stringr::str_extract(paths, id_pattern)
}


#' Find textgrid intervals that enclose another set of intervals
#'
#' Problem: You have two textgrid dataframes A and B, and the intervals in B are
#' enclosed inside of intervals of A. For example, let A be a set of intervals
#' of words and B be a set of intervals for segmented phonemes. You want to
#' match the intervals of the segmented phonemes in B to the intervals of words
#' in A. This function does this check, returning the dataframe B with an
#' additional column for each match it finds in A
#'
#' @param a textgrid dataframe containing the columns XMin, XMax
#' @param parent_df a textgrid dataframe containing the columns XMin, XMax plus
#'   an additional value column
#' @param value the name of the column to extract from parent_df if an
#'   enclosing interval is found
#' @return the original child_df with an additional column
find_enclosing_intervals <- function(child_df, parent_df, value) {
  # Create one-off function for looking up one enclosing interval in the current
  # parent_df
  find_these_intervals <- function(xl, xr) {
    find_one_enclosing_interval(xl, xr, parent_df, value)
  }

  # Construct an expression for mutate_ to evaluate. Basically we want:
  #   `mutate(child_df, value = unlist(Map(find_these_intervals, XMin, XMax)))`
  # But we need to make sure that "value" gets the correct name.
  dots <- list(~unlist(Map(find_these_intervals, XMin, XMax)))
  dots <- setNames(dots, value)

  # Find the enclosing interval for each row of the child df
  child_df %>%
    rowwise %>%
    mutate_(.dots = dots) %>%
    ungroup
}


#' Find one enclosing internal from one left boundary and one right boundary
#' @param xl xr singleton numeric values for the left and right boundaries of
#'   the range
#' @inheritParams find_enclosing_intervals
#' @return NA if no matches found; otherwise the value of the enclosing interval
find_one_enclosing_interval <- function(xl, xr, parent_df, value) {
  xmid <- median(c(xl, xr))
  matches <- filter(parent_df, XMin <= xmid, xmid <= XMax)
  stopifnot(nrow(matches) <= 1)
  if (nrow(matches) == 0) NA else matches[[value]]
}


#' Create a data-frame from a segmentation textgrid
#' @param grid_path path to a GFTA segmentation textgrid
tidy_segmentation_grid <- function(grid_path) {
  tg_segm <- TextGrid(grid_path)

  # Get Interval tiers in segmentation textgrid
  df_tg_segm <- data.frame(tg_segm) %>%
    filter(TierType == "Interval") %>%
    select(TextGrid:Text, -TierNumber)

  # Convert Point/Text Tiers to infinitesimal interval tiers
  df_tg_segm_texts <- data.frame(tg_segm) %>%
    filter(TierType == "Text") %>%
    mutate(XMin = Time, XMax = Time, Text = Mark, TierType = "Interval") %>%
    select(TextGrid, TierName, XMin, XMax, Text)

  # Add Point Tiers as Intervals Tiers
  df_tg_segm <- bind_rows(df_tg_segm, df_tg_segm_texts) %>%
    select(TextGrid, TierName, XMin, XMax, Text)

  # Remove inter-trial intervals
  `%nin%` <- Negate(`%in%`)
  df_iti <- df_tg_segm %>% filter(TierName == "Trial", is.na(Text))
  df_tg_segm <- df_tg_segm %>% filter(XMin %nin% df_iti$XMin)

  # Remove inter-repetition intervals
  df_iri <- df_tg_segm %>% filter(TierName == "Repetition", is.na(Text))
  df_tg_segm <- anti_join(df_tg_segm, df_iri, by = c("XMin", "XMax"))

  # Make data-frame of trial intervals
  df_trials <- df_tg_segm %>%
    filter(TierName == "Trial") %>%
    mutate(TrialNum = row_number(XMin))

  # For each interval, find the trial number that encloses that interval.
  # Assumes that all the Repetition, Context and SegmNote intervals fall within
  # exactly one Trial inverval
  df_tg_segm <- find_enclosing_intervals(df_tg_segm, df_trials, "TrialNum")

  # Get segmentation notes for each trial. Assumes there is only SegmNote per
  # Trial. If this is not true, update code to store notes in separate
  # data-frame or flatten multiple notes into one value
  df_notes <- df_tg_segm %>%
    filter(TierName %in% c("SegmNotes")) %>%
    spread(TierName, Text) %>%
    select(TextGrid, TrialNum, SegmNotes)

  # Add notes to trial-level information
  df_trial_info <- df_tg_segm %>%
    filter(TierName %in% c("Trial", "Word")) %>%
    spread(TierName, Text) %>%
    rename(TrialXMin = XMin, TrialXMax = XMax) %>%
    left_join(df_notes, c("TextGrid", "TrialNum"))

  # Add trial-level information to responses
  df_responses <- df_tg_segm %>%
    filter(TierName %nin% c("Trial", "Word", "SegmNotes")) %>%
    spread(TierName, Text) %>%
    rename(ResponseXMin = XMin, ResponseXMax = XMax) %>%
    left_join(df_trial_info, by = c("TextGrid", "TrialNum")) %>%
    mutate(ParticipantID = extract_pid(TextGrid)) %>%
    select(ParticipantID, TextGrid, TrialNum, TrialXMin, TrialXMax, Trial, Word,
           SegmNotes, Repetition, Context, ResponseXMin, ResponseXMax)
  df_responses
}



