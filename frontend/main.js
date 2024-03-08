// fetch video list
const logoutButton = document.getElementById('logoutBtn')
logoutButton.addEventListener('click', () => {
  window.location.href = '/logout'
})

  fetch('videoList')
    .then(response => response.json())
    .then(data => {
      // append options to link select with id in the value and description in the text
      const linkSelect = document.getElementById('link')
      for (const link in data) {
        const option = document.createElement('option')
        option.value = data[link]['videoID']
        option.text = data[link]['videoDescription']
        linkSelect.appendChild(option)
      }
    })

populateSendTemplateForm()

// send sms when send button is clicked
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

function fetchTemplateDetails(templateValue) {
  //clear form except for template

  fetch('templateDetails', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      templateId: templateValue
    })
  })
    .then(response => response.json())
    .then(data => {
      const properties = Object.keys(data)
      const preview = document.getElementById('preview')
      const templateForm = document.getElementById('sendTemplate')
      //clear everything after first child of sendTemplate
      while (templateForm.children.length > 1) {
        templateForm.removeChild(templateForm.lastChild)
      }

      // add break
      templateForm.appendChild(document.createElement('br'))
      templateForm.appendChild(document.createElement('br'))
      // append to number to form
      const toNumberLabel = document.createElement('label')
      toNumberLabel.htmlFor = 'toNumber'
      toNumberLabel.innerHTML = 'To: '
      templateForm.appendChild(toNumberLabel)
      const toNumber = document.createElement('input')
      toNumber.type = 'tel'
      toNumber.name = 'toNumber'
      toNumber.id = 'toNumber'
      templateForm.appendChild(toNumber)
      preview.innerHTML = ''
      // cycle through json, if the name of a property is "preview", the text should appear in the div id #previoew
      for (const property in properties) {
        // add label if property is not preview
        if (properties[property] !== 'Preview') {
          const label = document.createElement('label')
          label.htmlFor = properties[property]
          label.innerHTML = properties[property] + ': '
          templateForm.appendChild(label)
        }
        // add input
        if (data[properties[property]][0] === 'videos') {
          const videoSelect = document.createElement('select')
          videoSelect.name = properties[property]
          videoSelect.id = properties[property]
          templateForm.appendChild(videoSelect)
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

            })
        }
        switch (properties[property]) {
          case 'Preview':
            preview.innerHTML = ''
            p = document.createElement('p')
            p.innerHTML = data[properties[property]]
            preview.appendChild(p)
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
          case 'Phone':
            const phoneInput = document.createElement('input')
            phoneInput.type = 'tel'
            phoneInput.name = properties[property]
            templateForm.appendChild(phoneInput)
            break
          default:
            break
        }
        // add break
        templateForm.appendChild(document.createElement('br'))
        templateForm.appendChild(document.createElement('br'))
      }
      // add submit button to sendTemplate form
      const submitButton = document.createElement('button')
      submitButton.type = 'submit'
      submitButton.textContent = 'Send'
      templateForm.appendChild(submitButton)
      // remove event listeners from submit button
      submitButton.removeEventListener('submit', submitHandler)
    })
  // submit template form
  templateForm.addEventListener('submit', submitHandler)


}

function populateSendTemplateForm() {
  templateForm = document.getElementById('sendTemplate')
  // empty form
  templateForm.innerHTML = ''
  // add template select
  const templateSelect = document.createElement('select')
  templateSelect.name = 'template'
  templateSelect.id = 'template'
  templateForm.appendChild(templateSelect)
  // get template list
  fetch('templateList')
    .then(response => {
      if (response.redirected) {
        window.location.href = response.url
      } else {
        return response.json()
      }
    })
    .then(data => {
      // append options to template select with id in the value and description in the text
      for (const template in data) {
        const templateOption = document.createElement('option')
        templateOption.value = data[template]['template_id']
        templateOption.text = data[template]['template_name']
        templateSelect.appendChild(templateOption)
      }
      templateSelect.addEventListener('change', () => {
        fetchTemplateDetails(templateSelect.value)
      })
      fetchTemplateDetails(templateSelect.value)
    })
}

const submitHandler = (event) => {
  event.preventDefault()
  const formData = new FormData(templateForm)
  const formDataObject = {}
  for (const [key, value] of formData.entries()) {
    formDataObject[key] = value
  }
  const formDataWrapper = {
    templateParams: formDataObject
  }
  fetch('sendTemplate', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(formDataWrapper)
  })
    //expect index.html redirect and navigate to index.html
    .then(response => {
      if (response.redirected) {
        window.location.href = response.url
      } else {
        console.log(response)
      }
    })
}
document.addEventListener('DOMContentLoaded', function () {
    const tabs = document.querySelectorAll('.tab');
    const tabContents = document.querySelectorAll('.tabContent');

    tabs.forEach(tab => {
        tab.addEventListener('click', function () {
            const tabId = this.id.replace('tab', '');
            showTab(tabId);
        });
    });

    function showTab(tabId) {
        tabContents.forEach(content => {
            content.style.display = 'none';
        });

        tabs.forEach(tab => {
            tab.classList.remove('active');
        });

        const contentToShow = document.getElementById(`content${tabId}`);
        const tabToHighlight = document.getElementById(`tab${tabId}`);

        contentToShow.style.display = 'block';
        tabToHighlight.classList.add('active');
    }

    // Show the default tab on page load
    showTab('Templates');
});
