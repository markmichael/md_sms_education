send_template <- function(uuid_in, templateParams) {
  if (is.null(templateParams$template)) {
    templateParams$template <- "default"
  }
  ### source template function
  source(paste0("functions/templates/", templateParams$template, ".R"))
  twilio_response <- send_templated_message(templateParams$toNumber,
                                            Sys.getenv("TWILIO_FROM_NUMBER"),
                                            templateParams)

  ### record in db
  con <- connect_db()
  tbl(con, "messages") |>
    rows_insert(
      data.frame(
        message_id = twilio_response$sid,
        time_stamp = Sys.time(),
        uuid = uuid_in,
        origin_number = Sys.getenv("TWILIO_FROM_NUMBER"),
        destination_number = templateParams$toNumber,
        message_text = twilio_response$body,
        asset_type = "template",
        asset_id = templateParams$template
      ) |> copy_inline(con, df = _),
      conflict = "ignore",
      in_place = TRUE
    )


  return("success")
}
