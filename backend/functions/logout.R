logout <- function(session) {
  con <- connect_db()

  remove_session <- DBI::dbExecute(
    con,
    paste0("DELETE FROM restricted.session WHERE session_token = '", session, "'")
  )
  return("logout successful")
}
