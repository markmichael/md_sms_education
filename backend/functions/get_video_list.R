get_video_library <- function(uuid_in) {
  con <- connect_db()
  response <- tbl(con, "video_library") |>
    filter(owner_uuid == uuid_in) |>
    select(video_id,video_title) |>
    collect() |>
    setNames(c("videoID", "videoDescription")) |>
    apply(MARGIN = 1, FUN = as.list)
  return(response)
}
