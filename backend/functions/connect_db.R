connect_db <- function() {
  con <- DBI::dbConnect(
    drv = RPostgres::Postgres(),
    host = Sys.getenv("POSTGRES_HOST"),
    port = 5432,
    dbname = Sys.getenv("POSTGRES_DB"),
    user = Sys.getenv("POSTGRES_USER"),
    password = Sys.getenv("POSTGRES_PASSWORD")
  )
  return(con)
}
