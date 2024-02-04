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
  video_list <- get_video_library()
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
    uuid_admin <- check_session(session)
    if (length(uuid_admin) == 1) {
      res$status <- 302
      res$setHeader("Location", "/login.html")
      return(res)
    } else {
      send_message(toNumber, fromNumber = Sys.getenv("TWILIO_FROM_NUMBER"), customMessage, videoSelection) ## test number
      session <- generate_session(uuid_admin$uuid)
      res$setCookie(name = "session", value = session, path = "/", http = TRUE)
      res$body <- "success"
      return(res)
    }
  } # send_message(toNumber, fromNumber = "+18446260787", customMessage, videoSelection) ## live number
}

#* Create User
#* @post /createUser
#* @param email
#* @param firstName
#* @param lastName
#* @param password
createUser <- function(email, firstName, lastName, password, admin, req, res) {
  ### check for valid session in request cookies
  session <- req$cookies$session
  if (is.null(session)) {
    res$status <- 302
    res$setHeader("Location", "/login.html")
    return(res)
  } else {
    uuid_admin <- check_session(session)
    print(uuid_admin)
    if (length(uuid_admin) == 1 || !uuid_admin$admin) {
      res$status <- 302
      res$setHeader("Location", "/login.html")
      print("here i am")
      return(res)
    } else {
      a <- create_user(email, firstName, lastName, password, admin)
      session <- generate_session(uuid_admin$uuid)
      res$setCookie(name = "session", value = session, path = "/", http = TRUE)
      res$body <- a
      return(res)
    }
  }
}

#* Login
#* @post /login
#* @param username
#* @param password
#* @serializer html
login_user <- function(username, password, res) {
  session <- login(username, password)
  uuid_admin <- check_session(session)
  if (session == "Invalid Credentials") {
    return("Invalid Credentials")
  } else {
    ### set cookie
    res$setCookie(name = "session", value = session, path = "/", http = TRUE)
    res$status <- 302
    ### check if user is admin and redirect to admin page
    if (uuid_admin$admin) {
      res$setHeader("Location", "/admin.html")
    } else {
      res$setHeader("Location", "/index.html")
    }
    return(res)
  }
}

#* Add video
#* @post /addVideo
#* @param videoName
#* @param videoLink
addVideo <- function(videoName, videoLink, req, res) {
  ### check for valid session in request cookies
  session <- req$cookies$session
  if (is.null(session)) {
    res$status <- 302
    res$setHeader("Location", "/login.html")
    return(res)
  } else {
    uuid_admin <- check_session(session)
    if (length(uuid_admin) == 1 || !uuid_admin$admin) {
      res$status <- 302
      res$setHeader("Location", "/login.html")
      return(res)
    } else {
      a <- add_video(videoName, videoLink)
      res$body <- a
      return(res)
    }
  }
}

#* Fetch template list
#* @get /templateList
templateList <- function(req, res) {
  ### check for valid session in request cookies
  session <- req$cookies$session
  if (is.null(session)) {
    res$status <- 302
    res$setHeader("Location", "/login.html")
    return(res)
  } else {
    uuid_admin <- check_session(session)
    if (length(uuid_admin) == 1) {
      res$status <- 302
      res$setHeader("Location", "/login.html")
      return(res)
    } else {
      a <- get_template_library(uuid_admin$uuid)
      return(a)
    }
  }
}

#* Fetch template details
#* @post /templateDetails
#* @param templateId
templateDetails <- function(templateId, req, res) {
  ### check for valid session in request cookies
  session <- req$cookies$session
  if (is.null(session)) {
    res$status <- 302
    res$setHeader("Location", "/login.html")
    return(res)
  } else {
    uuid_admin <- check_session(session)
    if (length(uuid_admin) == 1) {
      res$status <- 302
      res$setHeader("Location", "/login.html")
      return(res)
    } else {
      a <- get_template_details(templateId)
      a$Preview <- gsub("\n", "<br>", a$Preview)
      return(a)
    }
  }
}

#* Send Template
#* @post /sendTemplate
#* @param templateParams
sendTemplate <- function(templateParams, req, res) {
  ### check for valid session in request cookies
  session <- req$cookies$session
  if (is.null(session)) {
    res$status <- 302
    res$setHeader("Location", "/login.html")
    return(res)
  } else {
    uuid_admin <- check_session(session)
    if (length(uuid_admin) == 1) {
      res$status <- 302
      res$setHeader("Location", "/login.html")
      return(res)
    } else {
      a <- send_template(templateParams)
      print(a)
      return("success")
    }
  }
}
