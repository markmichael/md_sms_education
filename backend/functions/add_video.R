add_video <- function(video_title_in, video_link_in, email_in) {
  con <- connect_db()
  ### get uuid of email_in
  uuid <- tbl(con, in_schema("restricted", "user")) |>
    filter(email == email_in) |>
    select(uuid) |>
    collect()
  uuid_in <- uuid$uuid
  ### check that title and link are not in db
  video_exist <- tbl(con, "video_library") |>
    filter((owner_uuid == uuid_in & video_title == video_title_in) |
      (owner_uuid == uuid_in & video_link == video_link_in)) |>
    collect() |>
    nrow()
  if (video_exist > 0) {
    return("video already in library")
  } else {
    new_video_id <- stringi::stri_rand_strings(1, 16)
    tbl(con, "video_library") |>
      rows_insert(
        data.frame(
          video_id = new_video_id,
          video_title = video_title_in,
          video_link = video_link_in,
          owner_uuid = uuid_in
        ) |> copy_inline(con, df = _),
        conflict = "ignore",
        in_place = TRUE
      )
    return("video successfully added to library")
  }
}
