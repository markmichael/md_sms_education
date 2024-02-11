send_message <- function(uuid_in, toNumber, fromNumber = Sys.getenv("TWILIO_FROM_NUMBER"), customMessage, videoSelection) {
  ## search video list for url where videoID matches videoSelection
  con <- connect_db()
  video <- tbl(con, "video_library") |>
    filter(video_id == videoSelection) |>
    collect()
  videoURL <- video$video_link
  videoDescription <- video$video_title
  twilio_response <- twilio::tw_send_message(
    to = toNumber,
    from = fromNumber,
    body = paste0(customMessage, " ", videoDescription, ": ", videoURL)
  )

  ### record in db
  tbl(con, "messages") |>
    rows_insert(
      data.frame(
        message_id = twilio_response$sid,
        time_stamp = Sys.time(),
        uuid = uuid_in,
        origin_number = twilio_response$from,
        destination_number = twilio_response$to,
        message_text = twilio_response$body,
        asset_type = "video",
        asset_id = videoSelection
      ) |> copy_inline(con, df = _),
      conflict = "ignore",
      in_place = TRUE
    )


  return("success")
}
