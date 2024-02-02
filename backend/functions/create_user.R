create_user <- function(email, first_name, last_name, passwordhash) {
  ### connect to database
  con <- connect_db()
  ### check if email is already in database
  user_exist <- tbl(con, "restricted.user") |>
    filter(email == email) |>
    collect() |>
    nrow()
  if (user_exist == 0) {
    ### create auth hash
    emailhash <- openssl::md5(email)
    user_access_hash <- openssl::sha512(paste0(emailhash, passwordhash))

    ### generate uuid
    uuid <- paste0(stringi::stri_rand_strings(1, 8, pattern = "[0-9a-h]"),
                   "-",
                   stringi::stri_rand_strings(1, 4, pattern = "[0-9a-h]"),
                   "-",
                   stringi::stri_rand_strings(1, 4, pattern = "[0-9a-h]"),
                   "-",
                   stringi::stri_rand_strings(1, 4, pattern = "[0-9a-h]"),
                   "-",
                   stringi::stri_rand_strings(1, 12, pattern = "[0-9a-h]"))

    ### store user in users table
    tbl(con, "restricted.user") |>
      rows_insert(
        data.frame(
          uuid = uuid,
          email = email,
          first_name = first_name,
          last_name = last_name
        )
      )

    ### store user access hash in login table
    tbl(con, "restricted.login") |>
      rows_insert(
        data.frame(
          uuid = uuid,
          user_access_hash = user_access_hash
        )
      )
    return("success")
  } else {
    return("email already in use")
  }
}
