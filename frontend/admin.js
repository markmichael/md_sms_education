// when submit button is clicked submit on the first form post call to create new user
// when submit button is clicked submit on the second form post call to add new video



const userForm = document.querySelector('#createUser')
userForm.addEventListener('submit', (event) => {
  event.preventDefault()
  const first_name = document.getElementById('first_name').value
  const last_name = document.getElementById('last_name').value
  const email = document.getElementById('email').value
  const password = document.getElementById('password').value
  const admin = document.getElementById('admin').checked
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
      password: hashedPassword,
      admin: admin
    })
  })
    .then(data => {
      console.log(data)
    })
})

const videoForm = document.querySelector('#addVideo')
videoForm.addEventListener('submit', (event) => {
  event.preventDefault()
  const name = document.getElementById('name').value
  const videolink = document.getElementById('videolink').value
  fetch('/addVideo', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      videoName: name,
      videoLink: videolink
    })
  })
    .then(data => {
      console.log(data)
    })
  .then(() => {
  fetch('videoList')
    .then(response => response.json())
    .then(data => {
      // append options to link select with id in the value and description in the text
      const linkSelect = document.getElementById('link')
      linkSelect.innerHTML = ''
      for (const link in data) {
        const option = document.createElement('option')
        option.value = data[link]['videoID']
        option.text = data[link]['videoDescription']
        linkSelect.appendChild(option)
      }
    })
  })
})

  fetch('videoList')
    .then(response => response.json())
    .then(data => {
      // append options to link select with id in the value and description in the text
      const linkSelect = document.getElementById('link')
      for (const link in data) {
        console.log(link)
        const option = document.createElement('option')
        option.value = data[link]['videoID']
        option.text = data[link]['videoDescription']
        linkSelect.appendChild(option)
      }
    })

const form = document.querySelector('#sendMessage')
form.addEventListener('submit', (event) => {
  event.preventDefault()
  const to = document.getElementById('to').value
  const message = document.getElementById('message').value
  const link = document.getElementById('link').value
  fetch('sendMessage', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      toNumber: to,
      customMessage: message,
      videoSelection: link
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
