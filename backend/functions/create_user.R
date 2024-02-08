create_user <- function(email_in, first_name, last_name, admin = FALSE) {
  email_in <- email_in |> tolower()
  ### connect to database
  con <- connect_db()
  ### check if email is already in database
  user_exist <- tbl(con, in_schema("restricted", "user")) |>
    filter(email == email_in) |>
    collect() |>
    nrow()
  if (user_exist == 0) {
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
          email = email_in,
          first_name = first_name,
          last_name = last_name,
          admin = admin
        ) |> copy_inline(con, df = _),
        conflict = "ignore",
        in_place = TRUE
      )

    return("success")
  } else {
    return("email already in use")
  }
}
