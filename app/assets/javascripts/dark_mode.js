var darkModeClasses = ['custom-navbar', 'narrow-recipe-card', 'page-container', 'text-box', 'welcome-banner', 'wide-recipe-card']

setInitialSwitchState()

$('#dark-mode-dropdown-switch, #dark-mode-expanded-switch').change(function(e) {
  toggleDarkMode(e.target.checked)
})

$('.dark-mode-switch-container').on('click', function(event){
  event.stopPropagation();
})

function setInitialSwitchState() {
  $.get('/current_user_data', function(result) {
    if(result != null) {
      $('#dark-mode-dropdown-switch, #dark-mode-expanded-switch').prop('checked', result.dark_mode);
    }
  });
}

function toggleDarkMode(darkModeOn) {
  $.get('/current_user_data', function(result) {
    if(result != null) {
      toggleClasses(darkModeOn);
      selectMode(result, darkModeOn);
    }
  });
}

function toggleClasses(darkModeOn) {
  $(darkModeClasses).each(function() {
    if(darkModeOn) {
      $(`.${this}`).addClass(`${this}-dark-mode`).removeClass(`${this}-light-mode`)
    } else {
      $(`.${this}`).addClass(`${this}-light-mode`).removeClass(`${this}-dark-mode`)
    }
  });
}


function selectMode(user, darkModeOn) {
  var url = `/users/toggle_dark_mode/${user.id}`
  // Read up on if you need to do something here in the event of an error
  $.ajax({
    type: 'patch',
    url: url,
    dataType: 'json',
    data: { 'user' : { 'dark_mode' : darkModeOn } }
  });
};
