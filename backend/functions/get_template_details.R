get_template_details <- function(templateId) {
  if (templateId == "") {
    templateId <- "default"
  }
  source(paste0("functions/templates/", templateId, ".R"))
  return(template_parameters)
}
