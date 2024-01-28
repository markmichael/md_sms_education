
#* @filter cors
cors <- function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")

  if (req$REQUEST_METHOD == "OPTIONS") {
    res$setHeader("Access-Control-Allow-Methods", "*")
    res$setHeader("Access-Control-Allow-Headers", req$HTTP_ACCESS_CONTROL_REQUEST_HEADERS)
    res$status <- 200
    return(list())
  } else {
    plumber::forward()
  }
}

#* Serve page
#* @assets ../frontend /
index <- function() {
  plumber::forward()
}

#* Get Video List
#* @get /videoList
videoList <- function() {
  source("./assets/video_list.R")
 video_list
}

#* Send Message
#* @post /sendMessage
#* @param toNumber
#* @param customMessage
#* @param videoSelection
sendMessage <- function(toNumber, customMessage, videoSelection) {
  source("./send_message.R")
  # send_message(toNumber, fromNumber = "+18446260787", customMessage, videoSelection) ## live number
  send_message(toNumber, fromNumber = "+15005550006", customMessage, videoSelection) ## test number
}
