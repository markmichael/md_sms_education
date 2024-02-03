check_session <- function(session) {
  con <- connect_db()
  session_check <- tbl(con, in_schema("restricted", "session")) |>
    left_join(tbl(con, in_schema("restricted", "user")), by = "uuid") |>
    filter(session_token == session) |>
    select(uuid, admin, session_create_time) |>
    collect()

  ### check if session exists
  if (nrow(session_check) == 1) {
    ### check how much time has passed since session creation
    if (difftime(Sys.time(),
      session_check$session_create_time,
      units = "mins"
    ) < Sys.getenv("SESSION_EXPIRE_TIME")) {
      return(list(uuid = session_check$uuid,
                  admin = session_check$admin))
    } else {
      return("session not valid")
    }
  } else {
    return("session not valid")
  }
}
