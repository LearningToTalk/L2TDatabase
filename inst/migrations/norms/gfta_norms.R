# Add the GFTA norms table to the norms database to faciliate look-up of
# standardized scores down the line.

library("L2TDatabase")
library("readr")
library("dplyr")
library("tidyr")
library("stringr")
library("ggplot2")



## Check the norms ------------------------------------------------------------

# Load OCR table of norms
norms <- read_csv("inst/migrations/norms/gfta_manual_cropping-repair.csv")

# Check for letters in columns that should only have numbers and punctuation
norms %>% filter(str_detect(standardScoreF, "[A-z]"))
norms %>% filter(str_detect(CI90F, "[A-z]"))
norms %>% filter(str_detect(CI95F, "[A-z]"))
norms %>% filter(str_detect(percentileF, "[A-z]"))

norms %>% filter(str_detect(standardScoreM, "[A-z]"))
norms %>% filter(str_detect(CI90M, "[A-z]"))
norms %>% filter(str_detect(CI95M, "[A-z]"))
norms %>% filter(str_detect(percentileM, "[A-z]"))

# Identify jumps in min raw score
norms %>%
  group_by(minAge) %>%
  mutate(minRawDiff = c(NA, diff(rawScoreMin))) %>%
  filter(minRawDiff != 1)

# Identify jumps in max raw score
norms %>%
  group_by(minAge) %>%
  mutate(maxRawDiff = c(NA, diff(rawScoreMax))) %>%
  # higher ages have larger ranges of scores that get lowest possible standard
  # score, so ignore maxRaw of 77 to ignore this feature
  filter(maxRawDiff != 1, rawScoreMax != 77)

# Max age is always 1 above min age
all((norms$maxAge - norms$minAge) == 1)

# Min raw is always equal to max raw, unless it's at the edge of the scale, when
# max raw is 77
norms %>%
  filter(norms$rawScoreMax - norms$rawScoreMin != 0, rawScoreMax != 77)

# Visually check the standard scores
norm_plot <- norms %>%
  mutate(standardScoreF = ifelse(standardScoreF == "<40", 39, standardScoreF),
         standardScoreM = ifelse(standardScoreM == "<40", 39, standardScoreM),
         standardScoreF = as.numeric(standardScoreF),
         standardScoreM = as.numeric(standardScoreM))

ggplot(norm_plot) +
  aes(x = rawScoreMin, y = standardScoreF) +
  geom_point() +
  facet_wrap("minAge", scales = "free")

ggplot(norm_plot) +
  aes(x = rawScoreMin, y = standardScoreM) +
  geom_point() +
  facet_wrap("minAge", scales = "free")



## Convert to long format -----------------------------------------------------

expand_range <- function(x, y) {
  data_frame(Score = seq(x, y), rawScoreMin = x, rawScoreMax = y)
}
expand_range(61, 77)

# Create rows for all values between min score and max score
all_scores <- norms %>%
  distinct(rawScoreMin, rawScoreMax) %>%
  select(rawScoreMin, rawScoreMax) %>%
  rowwise %>%
  do(expand_range(.$rawScoreMin, .$rawScoreMax)) %>%
  ungroup

all_scores %>% filter(Score < rawScoreMin)
all_scores %>% filter(rawScoreMax < Score)
all_scores %>% rowwise %>% filter(!between(Score, rawScoreMin, rawScoreMax))

scores <- norms %>%
  left_join(all_scores, by = c("rawScoreMin", "rawScoreMax")) %>%
  select(-rawScoreMin, -rawScoreMax) %>%
  mutate(AgeRange = sprintf("%s-%s", minAge, maxAge))

# Create a row for each age in MinAge:MaxAge
scores_age1 <- scores %>% select(-maxAge) %>% rename(Age = minAge)
scores_age2 <- scores %>% select(-minAge) %>% rename(Age = maxAge)
long_age_scores <- bind_rows(scores_age1, scores_age2)

# Rename columns so they can be split up
names(long_age_scores) <- names(long_age_scores) %>%
  str_replace("F$", "_Female") %>%
  str_replace("M$", "_Male") %>%
  str_replace("standardScore", "Standard") %>%
  str_replace("percentile", "Percentile")

long_scores <- long_age_scores %>%
  gather(Key, Value, -AgeRange, -Age, -Score) %>%
  separate(Key, into = c("Measure", "Gender")) %>%
  spread(Measure, Value) %>%
  select(AgeRange, Age, Gender, Score, Standard, CI90, CI95, Percentile) %>%
  arrange(Age, Score, Gender)

long_scores %>% write_csv("inst/migrations/norms/gfta_long.csv")
long_scores %>% lapply(unique)



## Add to database ------------------------------------------------------------

# Connect to norms database
cnf_file <- "inst/l2t_db.cnf"
norm_db <- l2t_connect(cnf_file, "norms")

# Make sure only new data is being added
gfta_current_rows <- tbl(norm_db, "GFTA2") %>% collect
gfta_new_rows <- anti_join(long_scores, gfta_current_rows) %>%
  arrange(Age, Score, Gender)

# Add to database
append_rows_to_table(norm_db, "GFTA2", gfta_new_rows)

# Make sure only new data is being added
gfta_current_rows <- tbl(norm_db, "GFTA2") %>% collect
gfta_new_rows <- anti_join(long_scores, gfta_current_rows) %>%
  arrange(Age, Score, Gender)
