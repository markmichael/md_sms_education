
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
  # send_message(toNumber, fromNumber = "+18446260787", customMessage, videoSelection) ## live number
  send_message(toNumber, fromNumber = "+15005550006", customMessage, videoSelection) ## test number
}

#* Create User 
#* @post /createUser
#* @param email
#* @param firstName
#* @param lastName
#* @param password
createUser <- function(email, firstName, lastName, password) {
  create_user(email, firstName, lastName, password)
}

#* Login
#* @post /login
#* @param username
#* @param password
login_user <- function(username, password) {
  session <- login(username, password)
  if (session == "Invalid Credentials") {
    return("Invalid Credentials")
  } else {
  ### set cookie
  res <- plumber::set_cookie(
    name = "session",
    value = session
  )
  }
}

