// when submit button is clicked submit post call to create new user
const form = document.querySelector('form')
form.addEventListener('submit', (event) => {
  event.preventDefault()
  const first_name = document.getElementById('first_name').value
  const last_name = document.getElementById('last_name').value
  const email = document.getElementById('email').value
  const password = document.getElementById('password').value
  const hashedPassword = md5(password)
  fetch('/createUser', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      firstName: first_name,
      lastName: last_name,
      email: email,
      password: hashedPassword
    })
  })
    .then(response => response.json())
    .then(data => {
      console.log(data)
    })
})
