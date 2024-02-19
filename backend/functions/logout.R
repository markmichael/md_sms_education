logout <- function(session) {
  con <- connect_db()

  remove_session <- tbl(con, in_schema("restricted", "session")) |>
    rows_delete(copy_inline(con, data.frame(session_token = session)),
    in_place = TRUE,
    by = "session_token",
    unmatched = "ignore")
  return("logout successful")
}
