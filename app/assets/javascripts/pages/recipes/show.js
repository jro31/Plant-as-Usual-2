$(function() {
  $('#process-display').click(function() {
    $('#process-input').height($(this).height());
    $(this).hide();
    $('#process-input').removeClass('d-none');
    $('#process-input').prop('disabled', false)
  });
});

// .prop("disabled", true)
