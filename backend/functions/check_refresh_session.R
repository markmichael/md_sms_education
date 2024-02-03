check_session <- function(session) {
  con <- connect_db()
  session_check <- tbl(con, in_schema("restricted", "session")) |>
    filter(session_token == session) |>
    collect()

  ### check if session exists
  if (nrow(session_check) == 1) {
    ### check how much time has passed since session creation
    if (difftime(Sys.time(),
                 session_check$session_create_time,
                 units = "hours") < 1) {
      return(session_check$uuid)
    } else {
      return("session not valid")
    }
  } else {
    return("session not valid")
  }
}
