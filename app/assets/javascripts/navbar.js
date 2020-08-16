// Try to get focus() on the search box when opened in the navbar
// Would be good to disable all other page clicks when the search box is open
$(function() {
  $('#search-input').val("")
})

$('#search-input').change(function() {
  $('#search-input').val().length > 0 ? $('#search-button').prop("disabled", false) : $('#search-button').prop("disabled", true);
})

$('#search-button-icon').click(function() {
  if($('#search-input').val().length === 0) {
    $('#search-logo').removeClass('show')
    $('#search-form-container').removeClass('show')
  }
})
