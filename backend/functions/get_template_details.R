get_template_details <- function(templateId) {
  source(paste0("functions/templates/", templateId, ".R"))
  return(template_parameters)
}
