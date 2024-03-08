library(dbplyr)
library(dplyr)
library(DBI)
source("backend/functions/connect_db.R")

con <- connect_db()

mark_uuid <- tbl(con, in_schema("restricted", "user")) |>
  filter(email == "markmichael14@gmail.com") |>
  select(uuid) |>
  collect()

dbSendQuery(con, paste0("ALTER TABLE video_library ",
                        "ADD COLUMN owner_uuid CHAR(36) NOT NULL",
                        " DEFAULT '", mark_uuid$uuid, "'"))

rm(mark_uuid)
