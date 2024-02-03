lapply(system("ls -d ./backend/functions/*.R", intern = TRUE), source)
library(dbplyr)
library(dplyr)
library(plumber)
pr("./backend/api.R") |>
  pr_run(port = 8000)
