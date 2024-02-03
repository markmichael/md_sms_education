create_user <- function(email, first_name, last_name, passwordhash) {
  email <- email |> tolower()
  ### connect to database
  con <- connect_db()
  ### check if email is already in database
  user_exist <- tbl(con, in_schema("restricted", "user")) |>
    filter(email == email) |>
    collect() |>
    nrow()
  if (user_exist == 0) {
    ### create auth hash
    emailhash <- openssl::md5(email)
    user_access_hash <- openssl::sha512(paste0(emailhash, passwordhash)) |>
      as.character()

    ### generate uuid
    uuid <- paste0(
      stringi::stri_rand_strings(1, 8, pattern = "[0-9a-h]"),
      "-",
      stringi::stri_rand_strings(1, 4, pattern = "[0-9a-h]"),
      "-",
      stringi::stri_rand_strings(1, 4, pattern = "[0-9a-h]"),
      "-",
      stringi::stri_rand_strings(1, 4, pattern = "[0-9a-h]"),
      "-",
      stringi::stri_rand_strings(1, 12, pattern = "[0-9a-h]")
    )

    ### store user in users table
    tbl(con, in_schema("restricted", "user")) |>
      rows_insert(
        data.frame(
          uuid = uuid,
          email = email,
          first_name = first_name,
          last_name = last_name
        ) |> copy_inline(con, df = _),
        conflict = "ignore",
        in_place = TRUE
      )

    ### store user access hash in login table
    tbl(con, in_schema("restricted", "login")) |>
      rows_insert(
        data.frame(
          uuid = uuid,
          user_access_hash = user_access_hash
        ) |> copy_inline(con, df = _),
        conflict = "ignore",
        in_place = TRUE
      )
    return("success")
  } else {
    return("email already in use")
  }
}
