library(dplyr)
library(L2TDatabase)

# Are you connected to the UMN network or VPN?




# Connection information is stored in .cnf files. Tristan probably created one
# for you already. To connect to the default database, point to the file.
my_cnf_file <- "./inst/l2t_db.cnf"
l2t <- l2t_connect(my_cnf_file)

# This is a database connection. You can see all the tables available to you.
l2t

# You can point to a table in the database with tbl().
tbl(l2t, "EVT")

# But to download a table, you need to collect() it.
df_evt <- tbl(l2t, "EVT") %>% collect()
df_evt

# You can manipulate the table
df_evt %>% filter(Study == "DialectSwitch")
df_evt %>% select(Study, ResearchID, EVT_GSV)

# Or plot it
library(ggplot2)
ggplot(df_evt) +
  aes(x = EVT_Age, y = EVT_GSV, color = Study) +
  geom_point()



# Many scores from a Study will be bundled together in the tables that start
# with "Scores_".
tp3 <- tbl(l2t, "Scores_TimePoint3") %>%
  collect()

# Don't worry about the warnings! Some numbers are computed on the fly whenever
# the table is requested, so R has to a conversion on those numbers.

# There are lots and lots of scores
tp3

ggplot(tp3) +
  aes(x = EVT_Standard, y = GFTA_Standard) +
  stat_smooth(method = "lm") +
  geom_point()




# Some tables are queries that target specific research designs. This one lets
# us compare how children who received multiple administrations of the minimal
# pairs task in different dialect performed.
df_minp <- tbl(l2t, "MinPair_Dialect_Summary") %>%
  collect()
df_minp

ggplot(df_minp) +
  aes(x = MinPair_AAE_ProportionCorrect, color = Child_Dialect) +
  geom_density()

ggplot(df_minp) +
  aes(x = MinPair_SAE_ProportionCorrect, color = Child_Dialect) +
  geom_density()

