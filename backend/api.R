#* @filter cors
cors <- function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")

  if (req$REQUEST_METHOD == "OPTIONS") {
    res$setHeader("Access-Control-Allow-Methods", "*")
    res$setHeader("Access-Control-Allow-Headers", req$HTTP_ACCESS_CONTROL_REQUEST_HEADERS)
    res$status <- 200
    return(list())
  } else {
    forward()
  }
}

#* Index
#* @assets ../frontend /
index <- function() {
  forward()
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
sendMessage <- function(toNumber, customMessage, videoSelection, req, res) {
  ### check for valid session in request cookies
  session <- req$cookies$session
  if (is.null(session)) {
    res$status <- 302
    res$setHeader("Location", "/login.html")
    return(res)
  } else {
    uuid <- check_session(session)
    if (uuid == "session not valid") {
      res$status <- 302
      res$setHeader("Location", "/login.html")
      return(res)
    } else {
  send_message(toNumber, fromNumber = "+15005550006", customMessage, videoSelection) ## test number
  session <- generate_session(uuid)
  res$setCookie(name = "session", value = session, path = "/", http = TRUE)
  res$body <- "success"
  return(res)
  }

  }   # send_message(toNumber, fromNumber = "+18446260787", customMessage, videoSelection) ## live number
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
#* @serializer html
login_user <- function(username, password, res) {
  session <- login(username, password)
  if (session == "Invalid Credentials") {
    return("Invalid Credentials")
  } else {
    ### set cookie
    res$setCookie(name = "session", value = session, path = "/", http = TRUE)
    res$status <- 302
    res$setHeader("Location", "/index.html")
    return(res)
  }
}
