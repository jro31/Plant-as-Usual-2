//= require rails-ujs
//= require_tree .
//= require jquery3


$(function() {
  $('#dark-mode').click(function() {
      selectMode();
  });
});


function selectMode() {
  $.get('/current_user_id', function(result) {
    var url = `/users/view_mode/${result.id}`
    $.ajax({
      type: 'post',
      url: url
    });
  });
};


