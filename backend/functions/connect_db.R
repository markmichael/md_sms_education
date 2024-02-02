connect_db <- function() {
  con <- DBI::dbConnect(
    drv = RPostgres::Postgres(),
    host = "localhost",
    port = 5432,
    dbname = "md_sms_db",
    user = "postgres",
    password = Sys.getenv("POSTGRES_PASSWORD")
  )
  return(con)
}
