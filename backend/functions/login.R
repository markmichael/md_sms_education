login <- function(username, password) {
  hash <- openssl::sha512(paste0(username, password)) |>
    as.character()
  ### connect to database
  con <- connect_db()

  user <- tbl(con, in_schema("restricted", "login")) |>
    filter(user_access_hash == hash) |>
    collect()
  ### check if username and password match
  if (nrow(user) == 1) {
    ### generate session
    session <- generate_session(user$uuid)

    return(
      session
    )
  } else {
    return("Invalid Credentials")
  }
}
