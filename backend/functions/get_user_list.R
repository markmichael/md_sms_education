get_user_list <- function() {
  con <- connect_db()
  email_list <- tbl(con, in_schema("restricted", "users")) |>
    select(email) |>
    collect() |>
    as.list()
  return(email_list)
}
