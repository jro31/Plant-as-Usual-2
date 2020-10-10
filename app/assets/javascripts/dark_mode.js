setInitialSwitchState()

$('#dark-mode-dropdown-switch, #dark-mode-expanded-switch').change(function(e) {
  toggleDarkMode(e.target.checked)
})

$('#dark-mode-switch-container').on('click', function(event){
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
  toggleClasses(darkModeOn);
  selectMode(darkModeOn);
}

function toggleClasses(darkModeOn) {
  if(darkModeOn) {
    $('body').addClass(`dark-mode`).removeClass(`light-mode`)
  } else {
    $('body').addClass(`light-mode`).removeClass(`dark-mode`)
  }
}


function selectMode(darkModeOn) {
  var url = `/users/toggle_dark_mode`
  // Read up on if you need to do something here in the event of an error
  $.ajax({
    type: 'patch',
    url: url,
    dataType: 'json',
    data: { 'user' : { 'dark_mode' : darkModeOn } }
  });
};
