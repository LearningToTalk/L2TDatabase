# Testing update queries to database

library("L2TDatabase")
library("dplyr", warn.conflicts = FALSE)

cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")

l2t_test <- l2t_connect(cnf_file, db_name = "l2ttest")

l2t_test %>% tbl("TestWrites") %>% collect

# Add rows to table
append_rows_to_table(
  src = l2t_test,
  tbl_name = "TestWrites",
  rows = data_frame(Message = c("Hello!", "Ahoy"))
)

l2t_test %>% tbl("TestWrites") %>% collect


overwrite_rows_in_table(
  src = l2t_test,
  tbl_name = "TestWrites",
  rows = data_frame(TestWritesID = 2:3, Message = c("Goodbye", "Farewell"))
)

overwrite_rows_in_table(
  src = l2t_test,
  tbl_name = "TestWrites",
  rows = data_frame(TestWritesID = 2:3, Message = c("Goodbye", "Farewell")),
  preview = FALSE
)


