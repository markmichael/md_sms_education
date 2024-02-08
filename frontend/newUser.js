// listen for submit form
document.getElementById('newUserForm').addEventListener('submit', function(event) {
  event.preventDefault()
  const email = document.getElementById('email').value
  const password = document.getElementById('newPassword').value
  const hashedPassword = md5(password)
  fetch('/setPassword', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      email: email,
      newPassword: hashedPassword
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
