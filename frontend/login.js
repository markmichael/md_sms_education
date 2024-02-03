//after clicking the submit button do an md5 hash of the email and the password and send it to login api call

const form = document.querySelector('form')
form.addEventListener('submit', (event) => {
  event.preventDefault()
  const email = document.getElementById('email').value
  const hashedemail = md5(email.toLowerCase())
  const password = document.getElementById('password').value
  const hashedPassword = md5(password)
  fetch('/login', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      username: hashedemail,
      password: hashedPassword
    })
  })
    //expect index.html redirect and navigate to index.html
    .then(response => {
      if (response.redirected) {
        window.location.href = response.url
      } else {
        console.log(response)
      }
    })
})
