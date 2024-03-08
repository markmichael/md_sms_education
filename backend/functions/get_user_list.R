get_user_list <- function() {
  con <- connect_db()
  email_list <- tbl(con, in_schema("restricted", "user")) |>
    select(email) |>
    collect()|>
    apply(MARGIN = 1, FUN = as.list)
  return(email_list)
}
