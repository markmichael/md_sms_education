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

#* login page
#* @get /login
#* @serializer html
login_page <- function() {
  a <- readLines("../frontend/login.html") |> paste0(collapse = "")
  return(a)
}

#* set password page
#* @get /newUser
#* @serializer html
set_password_page <- function() {
  a <- readLines("../frontend/newUser.html") |> paste0(collapse = "")
  return(a)
}

#* admin page
#* @get /admin
#* @serializer html
admin_page <- function(req, res) {
  ### check for valid session in request cookies
  session <- req$cookies$session
  if (is.null(session)) {
    res$status <- 302
    res$setHeader("Location", "/login")
    return(res)
  } else {
    uuid_admin <- check_session(session)
    if (length(uuid_admin) == 1) {
      res$status <- 302
      res$setHeader("Location", "/login")
      return(res)
    } else if (!uuid_admin$admin) {
      res$status <- 302
      res$setHeader("Location", "/login")
      return(res)
    } else {
      a <- readLines("../frontend/admin.html") |> paste0(collapse = "")
      return(a)
    }
  }
}

#* owner selection list
#* @get /userList
userList <- function(req, res) {
  ### check for valid session in request cookies
  session <- req$cookies$session
  if (is.null(session)) {
    res$status <- 302
    res$setHeader("Location", "/login")
    return(res)
  } else {
    uuid_admin <- check_session(session)
    if (length(uuid_admin) == 1) {
      res$status <- 302
      res$setHeader("Location", "/login")
      return(res)
    } else {
      a <- get_user_list()
      return(a)
    }
  }
}


#* Get regular user page
#* @get /messagePortal
#* @serializer html
user_page <- function(req, res) {
  ### check for valid session in request cookies
  session <- req$cookies$session
  if (is.null(session)) {
    res$status <- 302
    res$setHeader("Location", "/login")
    return(res)
  } else {
    uuid_admin <- check_session(session)
    if (length(uuid_admin) == 1) {
      res$status <- 302
      res$setHeader("Location", "/login")
      return(res)
    } else {
      a <- readLines("../frontend/index.html") |> paste0(collapse = "")
      return(a)
    }
  }
}

#* Get Video List
#* @get /videoList
videoList <- function(req) {
  session <- req$cookies$session
  if (is.null(session)) {
    res$status <- 302
    res$setHeader("Location", "/login")
    return(res)
  } else {
    uuid_admin <- check_session(session)
  }
  video_list <- get_video_library(uuid_admin$uuid)
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
    res$setHeader("Location", "/login")
    return(res)
  } else {
    uuid_admin <- check_session(session)
    if (length(uuid_admin) == 1) {
      res$status <- 302
      res$setHeader("Location", "/login")
      return(res)
    } else {
      send_message(uuid = uuid_admin$uuid, toNumber = toNumber, fromNumber = Sys.getenv("TWILIO_FROM_NUMBER"), customMessage, videoSelection) ## test number
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
createUser <- function(email, firstName, lastName, admin, req, res) {
  ### check for valid session in request cookies
  session <- req$cookies$session
  if (is.null(session)) {
    res$status <- 302
    res$setHeader("Location", "/login")
    return(res)
  } else {
    uuid_admin <- check_session(session)
    print(uuid_admin)
    if (length(uuid_admin) == 1 || !uuid_admin$admin) {
      res$status <- 302
      res$setHeader("Location", "/login")
      print("here i am")
      return(res)
    } else {
      a <- create_user(email, firstName, lastName, admin)
      session <- generate_session(uuid_admin$uuid)
      res$setCookie(name = "session", value = session, path = "/", http = TRUE)
      res$body <- a
      return(res)
    }
  }
}

#* Set password
#* @post /setPassword
#* @param email
#* @param newPassword
setPassword <- function(email, newPassword, req, res) {
  a <- set_password(email, newPassword)
  ## redirect to login
  res$status <- 302
  res$setHeader("Location", "/login")
  return(res)
}

#* Login
#* @post /login_user
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
    print(uuid_admin)
    if (uuid_admin$admin) {
      res$setHeader("Location", "/admin")
    } else {
      res$setHeader("Location", "/messagePortal")
    }
    return(res)
  }
}

#* Logout
#* @get /logout
logout_user <- function(req, res) {
  session <- req$cookies["session"]
  if (is.null(session)) {
    res$status <- 302
    res$setHeader("Location", "/login")
    return(res)
  } else {
    a <- logout(session)
    res$status <- 302
    res$setHeader("Location", "/login")
    return(res)
  }
}

#* Add video
#* @post /addVideo
#* @param videoName
#* @param videoLink
#* @param ownerEmail
addVideo <- function(videoName, videoLink, ownerEmail, req, res) {
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
      a <- add_video(videoName, videoLink, ownerEmail)
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
      a <- send_template(uuid_admin$uuid, templateParams)
      print(a)
      return("success")
    }
  }
}
