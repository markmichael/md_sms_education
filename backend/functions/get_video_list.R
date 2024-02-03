get_video_library <- function() {
  con <- connect_db()
  response <- tbl(con, "video_library") |>
    select(video_id,video_title) |>
    collect() |>
    setNames(c("videoID", "videoDescription")) |>
    apply(MARGIN = 1, FUN = as.list)
  return(response)
}
