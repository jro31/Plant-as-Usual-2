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
  $.get('/current_user_id', function(result) {
    var url = `/users/toggle_dark_mode/${result.id}`
    $.ajax({
      type: 'post',
      url: url
    });
  });
};


