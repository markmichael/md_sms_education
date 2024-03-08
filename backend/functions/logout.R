logout <- function(session) {
  con <- connect_db()

  remove_session <- DBI::dbExecute(
    con,
    paste0("DELETE FROM sessions WHERE session = '", session, "'")
  )
  return("logout successful")
}
