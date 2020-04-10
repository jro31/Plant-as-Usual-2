const inputs = ['name', 'process']

$(function() {
  $(document).click(function(click) {
    inputs.forEach((input) => {
      if(inputIsEnabled(input) && clickIsOutsideInput(click, input)) {
        // Save input
        // After save, disable/hide input and show display
      }
    })
  })

  $('#name-display').click(function() {
    $('#name-input').height($(this).height());
    $(this).hide();
    $('#name-input').removeClass('d-none');
    $('#name-input').prop('disabled', false)
  });

  $('#process-display').click(function() {
    $('#process-input').height($(this).height());
    $(this).hide();
    $('#process-input').removeClass('d-none');
    $('#process-input').prop('disabled', false)
  });
});

function inputIsEnabled(input) {
  return $(`#${input}-input`).prop('disabled') === false
}

function clickIsOutsideInput(click, input) {
  return click.target.id !== `${input}-input`
}
