send_message <- function(toNumber, fromNumber = "+15005550006", customMessage, videoSelection) {
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
  print(twilio_response)
  return("success")
}
