
#' Create a child object
#' @export
Child <- function(...) {
  defaults <- list(
    Female = NA, AAE = NA, LateTalker = NA, CImplant = NA,
    Birthdate = as.Date(NA), Note = NA)

  # Convert args to list, converting TRUE/FALSE to 1/0
  dots <- list(...)
  converted_logicals <- dots %>%
    Filter(is.logical, .) %>%
    lapply(as.numeric)
  dots <- merge_lists(dots, converted_logicals)

  # Drop arguments not in the defaults
  dots <- dots[intersect(names(defaults), names(dots))]
  structure(merge_lists(defaults, dots), class = c("Child", "list"))
}


#' Add Child objects to the Child table
#' @export
add_children <- function(db_con, children) {
  # Make sure that we have a list of Child objects
  children <- if (inherits(children, "Child")) list(children) else children
  assert_that(all(sapply(children, inherits, "Child")))

  # Convert the list of Childs into a dataframe
  child_rows <- bind_rows(lapply(as.list(children), as_data_frame))
  append_rows_to_table(db_con, tbl_name = "Child", child_rows)
}

#' @export
print.Child <- function(...) str(...)

