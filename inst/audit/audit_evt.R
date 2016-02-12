#' ---
#' title: "EVT Score Audit"
#' author: "Tristan Mahr"
#' ---

#+ setup, include = FALSE
library("knitr")
opts_chunk$set(collapse = TRUE, comment = "#>", message = FALSE)
opts_knit$set(root.dir = "../../")


#' Script to check for inconsistencies in the EVT scores in the database.

#+ connect
# Connect to db
library("L2TDatabase")
library("dplyr", warn.conflicts = FALSE)
cnf_file <- "./inst/l2t_db.cnf"
l2t <- l2t_connect(cnf_file)

# Combine child, study, childstudy, and evts tbls
evts <- tbl(l2t, "ChildStudy")  %>%
  left_join("Study" %from% l2t) %>%
  left_join("Child" %from% l2t) %>%
  left_join("EVT" %from% l2t) %>%
  # Download rows for kids with raw scores
  filter(!is.na(EVT_Raw)) %>%
  select(Study, ID = ShortResearchID, Birthdate, EVT_Form:EVT_Age) %>%
  collect

# Download Form A norms
evt_norms <- l2t_connect(cnf_file, "norms") %>%
  tbl("EVT2") %>%
  collect

# Make a form of the table amenable for score checking
norm_check <- evts %>%
  # Round age up to 30 months if younger than test norms
  mutate(Age = ifelse(EVT_Age < 30, 30, EVT_Age)) %>%
  rename(Raw = EVT_Raw, OurStnd = EVT_Standard, OurGSV = EVT_GSV) %>%
  select(-EVT_Age, -Birthdate, -EVT_Completion)




#' ## Preliminary checks
#'
#' ### Missing Dates
evts %>%
  filter(is.na(EVT_Completion)) %>%
  select(Study:EVT_Completion)

#' ### Missing Forms
#'
#' There should be lots of missing forms because both sites haven't documented
#' the test form consistently.
evts %>%
  filter(is.na(EVT_Form)) %>%
  select(Study:EVT_Completion) %>%
  arrange(Study, ID) %>%
  # Print every row
  as.data.frame()

#' ### Ages
#'
#' Recompute test ages and compare to age in EVT table
evts %>%
  select(Study, ID, Birthdate, EVT_Completion, EVT_Age) %>%
  filter(!is.na(EVT_Completion)) %>%
  mutate(ChronoAge = chrono_age(Birthdate, EVT_Completion)) %>%
  filter(EVT_Age != ChronoAge) %>%
  select(-Birthdate)



#' ## Derived Scores


#' ### Form B scores
#'
#' We cannot automatically check these scores because we only have the Form A
#' norms.
norm_check %>% filter(EVT_Form == "B")

#' ### Form A checks

# Get norms for each Age, Raw Score
form_a <- norm_check %>%
  filter(EVT_Form %in% "A") %>%
  left_join(evt_norms) %>%
  select(Study:EVT_Form, NormAge = Age, Raw, OurStnd, Stnd, OurGSV, GSV)

#' #### GSVs
form_a %>% filter(OurGSV != GSV)

#' #### Standard Scores
form_a %>% filter(OurStnd != Stnd) %>% arrange(Study, ID)

#' ### Form NA checks
#'
#' Assume that all tests with missing forms are just Form A tests.
form_na <- norm_check %>%
  filter(is.na(EVT_Form)) %>%
  left_join(evt_norms) %>%
  select(Study:EVT_Form, NormAge = Age, Raw, OurStnd, Stnd, OurGSV, GSV)

#' #### GSVs
form_na %>% filter(OurGSV != GSV)

#' #### Standard Scores
form_na %>% filter(OurStnd != Stnd) %>% arrange(Study, ID)
