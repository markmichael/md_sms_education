generate_session <- function(uuid) {
  ### connect to database
  con <- connect_db()
    session <- random_cookie_key()
    ### store session in session table
    tbl(con, in_schema("restricted", "session")) |>
      rows_upsert(
        data.frame(
          uuid = uuid,
          session_token = session,
          session_create_time = Sys.time()
        ) |> copy_inline(con, df = _),
        by = "uuid",
        in_place = TRUE
      )
    return(session)
}
