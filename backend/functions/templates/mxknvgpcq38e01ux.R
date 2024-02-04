template_parameters <- list(
  Preview = paste0(
    "Your child is scheduled for surgery with [Surgeon] at [Location] on [Date] at [Time]. Please arrive at [Time - 1 hr].\n",
    "Here is a video on how to prepare for the surgery:\n",
    "[videos1]\n",
    "Here is a video on what to expect afer surgery:\n",
    "[videos2]\n",
    "Please contact our office at [Phone] if you have any questions."
  ),
  Provider = list(
    "Dr. Canadas",
    "Dr. Duck"
  ),
  Date = "Date",
  Time = "Time",
  Location = list(
    "Texas Children's Hospital, West Campus (18200 Katy Fwy, Houston, TX 77094)",
    "Texas Children's Hospital, West Campus (18200 Katy Fwy, Houston, TX 77094)",
    "NW Surgery Center (4800 Federal Plaza Dr, Houston, TX 77092)"
  ),
  videos1 = "videos",
  videos2 = "videos",
  Phone = "Phone"
)

sent_templated_message <- function(to_number, from_number, template_parameters){
message <- paste0(
  "Your child is scheduled for surgery with ",
  template_parameters$Surgeon,
  " at ",
  template_parameters$Location,
  " on ",
  template_parameters$Date,
  " at ",
  template_parameters$Time,
  ". Please arrive at ",
  (template_paramters$Time - hours(1)),
  ".\n",
  "Here is a video on how to prepare for the surgery:\n",
  template_parameters$videos1,
  "\nHere is a video on what to expect afer surgery:\n",
  template_parameters$videos2,
  "\nPlease contact our office at ",
  template_parameters$Phone,
  " if you have any questions."
)
a <- tw_send_message(to_number, from_number, message)
return(a)
}
