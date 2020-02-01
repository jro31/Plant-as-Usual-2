var darkModeClasses = ['navbar', 'page-container', 'recipe-card']

$(function() {
  $('#dark-mode').click(function() {
      toggleDarkMode();
  });
});

function toggleDarkMode() {
  $.get('/current_user_data', function(result) {
    if(result != null) {
      toggleClasses();
      selectMode(result);
    }
  });
}

function toggleClasses() {
  $(darkModeClasses).each(function() {
    $(`.${this}`).toggleClass(`${this}-light-mode ${this}-dark-mode`)
  });
}


function selectMode(user) {
  var url = `/users/toggle_dark_mode/${user.id}`
  var newDarkMode = !user.dark_mode
  $.ajax({
    type: 'patch',
    url: url,
    dataType: 'json',
    data: { 'user' : { 'dark_mode' : newDarkMode } }
  });
};
