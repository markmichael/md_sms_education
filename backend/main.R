library(plumber)
source("./send_message.R")

pr("api.R") |>
  pr_run(port = 8000)
