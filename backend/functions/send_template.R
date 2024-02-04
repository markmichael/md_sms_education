send_template <- function(templateParams) {
  ### source template function
  source(paste0("functions/templates/", templateParams$template, ".R"))
  a <- send_templated_message(templateParams$toNumber, Sys.getenv("TWILIO_FROM_NUMBER"), templateParams)
  return(a)
}
