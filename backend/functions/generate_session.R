generate_session <- function(uuid) {
  ### connect to database
  con <- connect_db()
    session <- stringi::stri_rand_strings(1, 32)
    ### store session in session table
    tbl(con, "restricted.session") |>
      rows_upsert(
        data.frame(
          uuid = user$uuid,
          session = session,
          created_at = Sys.time()
        ),
        by = "uuid",
        in_place = TRUE
      )
    return(session)
}
