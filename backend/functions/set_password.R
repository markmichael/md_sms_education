set_password <- function(email_in, passwordhash) {
  email_in <- email_in |> tolower()
  con <- connect_db()

  ### check if email is in user database
  user <- tbl(con, in_schema("restricted", "user")) |>
    filter(email == email_in) |>
    collect()
  ### get uuid
  uuid_in <- user$uuid
  ### check that user not already in login database
  user_exist <- tbl(con, in_schema("restricted", "login")) |>
    filter(uuid == uuid_in) |>
    collect() |>
    nrow()

  if (nrow(user) == 1 && user_exist == 0) {
    ### create auth hash
    emailhash <- openssl::md5(email_in)
    user_access_hash <- openssl::sha512(paste0(emailhash, passwordhash)) |>
      as.character()
    ### record uuid and hash in login table
    tbl(con, in_schema("restricted", "login")) |>
      rows_insert(
        data.frame(
          uuid = uuid_in,
          user_access_hash = user_access_hash
        ) |> copy_inline(con, df = _),
        conflict = "ignore",
        in_place = TRUE
      )
    return("success")
  } else {
    return("email not eligible")
  }
}
