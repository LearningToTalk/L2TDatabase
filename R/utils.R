# Merge list y into list x
merge_lists <- function(x, y) {
  x[names(y)] <- y
  x
}
