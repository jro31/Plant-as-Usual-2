//= require rails-ujs
//= require_tree .
//= require jquery3

var darkModeClasses = ['navbar', 'page-container', 'recipe-card']

$(function() {
  $('#dark-mode').click(function() {
      toggleClasses();
      selectMode();
  });
});

function toggleClasses() {
  $(darkModeClasses).each(function() {
    $(`.${this}`).toggleClass(`${this}-light-mode ${this}-dark-mode`)
  });
}


function selectMode() {
  $.get('/current_user_data', function(result) {
    var url = `/users/toggle_dark_mode/${result.id}`
    var newDarkMode = !result.dark_mode
    $.ajax({
      type: 'patch',
      url: url,
      dataType: 'json',
      data: { 'user' : { 'dark_mode' : newDarkMode } }
    });
  });
};


