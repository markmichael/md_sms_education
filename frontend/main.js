// fetch video list
const url = document.URL

console.log(url)
  fetch(url+'videoList')
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

// send sms when send button is clicked
const form = document.querySelector('form')
form.addEventListener('submit', (event) => {
  event.preventDefault()
  const to = document.getElementById('to').value
  const message = document.getElementById('message').value
  const link = document.getElementById('link').value
  fetch(url+'sendMessage', {
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
})
