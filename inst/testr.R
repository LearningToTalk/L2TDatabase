library("L2TDatabase")

# initialize a cnf file
make_cnf_template()
make_cnf_template(user = "tj", db = "l2t")
file.remove("db.cnf")

# connect to the database
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file)
l2t

# backup
backup_dir <- "inst/backup"
all_tbls <- l2t_backup(l2t, backup_dir)
all_tbls$Study
