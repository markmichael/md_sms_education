get_template_library <- function(uuid_in) {
  con <- connect_db()
  templates <- tbl(con, "templates") |>
    filter(uuid_owner == uuid_in) |>
    select(template_id, template_name) |>
    collect() |>
    apply(MARGIN = 1, FUN = as.list)
  return(templates)
}
