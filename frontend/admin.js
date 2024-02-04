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
//fetch template list
fetch('templateList')
  .then(response => response.json())
  .then(data => {
    // append options to template select with id in the value and description in the text
    const templateSelect = document.getElementById('template')
    for (const template in data) {
      const option = document.createElement('option')
      option.value = data[template]['template_id']
      option.text = data[template]['template_name']
      // add event listener to fetch template details when an option is selected
      option.addEventListener('click', () => {
        fetch('templateDetails', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            templateID: option.value
          })
        })
          .then(response => response.json())
          .then(data => {
            const properties = Object.keys(data)
            const preview = document.getElementById('preview')
            const templateForm = document.getElementById('sendTemplate')
            preview.innerHTML = ''
            // cycle through json, if the name of a property is "preview", the text should appear in the div id #previoew
            for (const property in properties) {
              switch (properties[property]) {
                case 'preview':
                  preview.innerHTML = data[properties[property]]
                  break
                case 'Location':
                  // cycle through list of locations and create a dropdown in the sendTemplate form
                  for (const location in data[properties[property]]) {
                    const locationOption = document.createElement('option')
                    locationOption.value = data[properties[property]][location]
                    locationOption.text = data[properties[property]][location]
                    locationOption.name = properties[property]
                    templateForm.appendChild(locationOption)
                  }
                  break
                case 'Provider':
                  // add a dropdown to sendTemplate form
                  const providerSelect = document.createElement('select')
                  providerSelect.name = properties[property]
                  templateForm.appendChild(providerSelect)
                  // cycle through list of providers and create a dropdown in the sendTemplate form
                  for (const provider in data[properties[property]]) {
                    const providerOption = document.createElement('option')
                    providerOption.value = data[properties[property]][provider]
                    providerOption.text = data[properties[property]][provider]
                    providerOption.name = properties[property]
                    providerSelect.appendChild(providerOption)
                  }
                  break
                case 'Date':
                  // add a date input to sendTemplate form
                  const dateInput = document.createElement('input')
                  dateInput.type = 'date'
                  dateInput.name = properties[property]
                  templateForm.appendChild(dateInput)
                  break
                case 'Time':
                  // add a time input to sendTemplate form
                  const timeInput = document.createElement('input')
                  timeInput.type = 'time'
                  timeInput.name = properties[property]
                  templateForm.appendChild(timeInput)
                  break
                case 'videos':
                  const videoSelect = document.createElement('select')
                  videoSelect.name = properties[property]
                  // get video list
                  fetch('videoList')
                    .then(response => response.json())
                    .then(data => {
                      // append options to video select with id in the value and description in the text
                      for (const video in data) {
                        const videoOption = document.createElement('option')
                        videoOption.value = data[video]['videoID']
                        videoOption.text = data[video]['videoDescription']
                        videoSelect.appendChild(videoOption)
                      }
                      templateForm.appendChild(videoSelect)

                    })
                  break
                case 'Phone':
                  const phoneInput = document.createElement('input')
                  phoneInput.type = 'tel'
                  phoneInput.name = properties[property]
                  templateForm.appendChild(phoneInput)
                  break
                default:
                  break
              }
            }
            // add submit button to sendTemplate form
            const submitButton = document.createElement('button')
            submitButton.type = 'submit'
            submitButton.textContent = 'Send'
            templateForm.appendChild(submitButton)

          })

      })

      templateSelect.appendChild(option)
const firstTemplateOption = document.getElementById('template').firstElementChild
fetchTemplateDetails(firstTemplateOption)
    }
  })

function fetchTemplateDetails(firstTemplateOption) {
fetch('templateDetails', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    templateId: firstTemplateOption.value
  })
})
  .then(response => response.json())
  .then(data => {
    const properties = Object.keys(data)
    const preview = document.getElementById('preview')
    const templateForm = document.getElementById('sendTemplate')
    preview.innerHTML = ''
    // cycle through json, if the name of a property is "preview", the text should appear in the div id #previoew
    for (const property in properties) {
      switch (properties[property]) {
        case 'preview':
          preview.innerHTML = data[properties[property]]
          break
        case 'Location':
          // add a dropdown to sendTemplate form
          const locationSelect = document.createElement('select')
          locationSelect.name = properties[property]
          templateForm.appendChild(locationSelect)
          // cycle through list of locations and create a dropdown in the sendTemplate form
          for (const location in data[properties[property]]) {
            const locationOption = document.createElement('option')
            locationOption.value = data[properties[property]][location]
            locationOption.text = data[properties[property]][location]
            locationOption.name = properties[property]
            locationSelect.appendChild(locationOption)
          }
          break
        case 'Provider':
          // add a dropdown to sendTemplate form
          const providerSelect = document.createElement('select')
          providerSelect.name = properties[property]
          templateForm.appendChild(providerSelect)
          // cycle through list of provider and create a dropdown in the sendTemplate form
          for (const provider in data[properties[property]]) {
            const providerOption = document.createElement('option')
            providerOption.value = data[properties[property]][provider]
            providerOption.text = data[properties[property]][provider]
            providerOption.name = properties[property]
            providerSelect.appendChild(providerOption)
          }
          break
        case 'Date':
          // add a date input to sendTemplate form
          const dateInput = document.createElement('input')
          dateInput.type = 'date'
          dateInput.name = properties[property]
          templateForm.appendChild(dateInput)
          break
        case 'Time':
          // add a time input to sendTemplate form
          const timeInput = document.createElement('input')
          timeInput.type = 'time'
          timeInput.name = properties[property]
          templateForm.appendChild(timeInput)
          break
        case 'videos':
          const videoSelect = document.createElement('select')
          videoSelect.name = properties[property]
          // get video list
          fetch('videoList')
            .then(response => response.json())
            .then(data => {
              // append options to video select with id in the value and description in the text
              for (const video in data) {
                const videoOption = document.createElement('option')
                videoOption.value = data[video]['videoID']
                videoOption.text = data[video]['videoDescription']
                videoSelect.appendChild(videoOption)
              }
              templateForm.appendChild(videoSelect)

            })
          break
        case 'Phone':
          const phoneInput = document.createElement('input')
          phoneInput.type = 'tel'
          phoneInput.name = properties[property]
          templateForm.appendChild(phoneInput)
          break
        default:
          break
      }
    }
    // add submit button to sendTemplate form
    const submitButton = document.createElement('button')
    submitButton.type = 'submit'
    submitButton.textContent = 'Send'
    templateForm.appendChild(submitButton)

  })
}


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
