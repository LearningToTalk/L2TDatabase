#' ---
#' title: "PPVT Score Audit"
#' author: "Tristan Mahr"
#' ---

#+ setup, include = FALSE
library("knitr")
opts_chunk$set(collapse = TRUE, comment = "#>", message = FALSE)
wd <- rprojroot::find_rstudio_root_file()
opts_knit$set(root.dir = wd)


#' Script to check for inconsistencies in the PPVT scores in the database.

#+ connect
# Connect to db
library("L2TDatabase")
library("dplyr", warn.conflicts = FALSE)
cnf_file <- "inst/l2t_db.cnf"
l2t <- l2t_connect(cnf_file, "backend")

# Combine child, study, childstudy, and ppvts tbls
ppvts <- tbl(l2t, "ChildStudy")  %>%
  left_join("Study" %from% l2t) %>%
  left_join("Child" %from% l2t) %>%
  left_join("PPVT" %from% l2t) %>%
  # Download rows for kids with raw scores
  filter(!is.na(PPVT_Raw)) %>%
  select(Study, ID = ShortResearchID, Birthdate, PPVT_Form:PPVT_Age) %>%
  collect

# Download Form A norms
ppvt_norms <- l2t_connect(cnf_file, "norms") %>%
  tbl("PPVT4") %>%
  collect

# Make a form of the table amenable for score checking
norm_check <- ppvts %>%
  # Round age up to 30 months if younger than test norms
  mutate(Age = ifelse(PPVT_Age < 30, 30, PPVT_Age)) %>%
  rename(Raw = PPVT_Raw, OurStnd = PPVT_Standard, OurGSV = PPVT_GSV) %>%
  select(-PPVT_Age, -Birthdate, -PPVT_Completion)




#' ## Preliminary checks
#'
#' ### Missing Dates
ppvts %>%
  filter(is.na(PPVT_Completion)) %>%
  select(Study:PPVT_Completion)

#' ### Missing Forms
#'
#' There should be lots of missing forms because both sites haven't documented
#' the test form consistently.
ppvts %>%
  filter(is.na(PPVT_Form)) %>%
  select(Study:PPVT_Completion) %>%
  arrange(Study, ID) %>%
  # Print every row
  as.data.frame

#' ### Ages
#'
#' Recompute test ages and compare to age in PPVT table
ppvts %>%
  select(Study, ID, Birthdate, PPVT_Completion, PPVT_Age) %>%
  filter(!is.na(PPVT_Completion)) %>%
  mutate(ChronoAge = chrono_age(Birthdate, PPVT_Completion)) %>%
  filter(PPVT_Age != ChronoAge) %>%
  select(-Birthdate)



#' ## Derived Scores


#' ### Form B scores
#'
#' We cannot automatically check these scores because we only have the Form A
#' norms.
norm_check %>% filter(PPVT_Form == "B")

#' ### Form A checks

# Get norms for each Age, Raw Score
form_a <- norm_check %>%
  filter(PPVT_Form %in% "A") %>%
  left_join(ppvt_norms) %>%
  select(Study:PPVT_Form, NormAge = Age, Raw, OurStnd, Stnd, OurGSV, GSV)

#' #### GSVs
form_a_gsv <- form_a %>% filter(OurGSV != GSV)
form_a_gsv

#' #### Standard Scores
form_a_std <- form_a %>% filter(OurStnd != Stnd) %>% arrange(Study, ID)
form_a_std

#' ### Form NA checks
#'
#' Assume that all tests with missing forms are just Form A tests.
form_na <- norm_check %>%
  filter(is.na(PPVT_Form)) %>%
  left_join(ppvt_norms) %>%
  select(Study:PPVT_Form, NormAge = Age, Raw, OurStnd, Stnd, OurGSV, GSV)

#' #### GSVs
form_na_gsv <- form_na %>% filter(OurGSV != GSV)
form_na_gsv

#' #### Standard Scores
form_na_std <- form_na %>% filter(OurStnd != Stnd) %>% arrange(Study, ID)
form_na_std


results <- bind_rows(form_na_gsv, form_na_std, form_a_std, form_a_gsv)

results <- data_frame(
  Check = "PPVT",
  Date = format(Sys.Date()),
  Passing = nrow(results) == 0)

readr::write_csv(results, "./inst/audit/results_ppvt.csv")
