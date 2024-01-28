send_message <- function(toNumber, fromNumber = "+15005550006", customMessage, videoSelection) {
source("./assets/video_list.R")
## search video list for url where videoID matches videoSelection
videoURL <- video_list[[which(sapply(video_list, function(x) x$videoID ==  videoSelection))]]$videoURL
twilio_response <- twilio::tw_send_message(
to = toNumber,
from = fromNumber,
body = paste0(customMessage, " ", videoURL))
print(twilio_response)
return("success")
}
