get_video_library <- function() {
  con <- connect_db()
  response <- tbl(con, "video_library") |>
    select(video_title, video_link) |>
    collect() |>
    apply(MARGIN = 1, FUN = as.list)
  return(response)
}
