const inputIdPrefixes = ['name', 'process']

$(function() {
  $(document).click(function(click) {
    inputIdPrefixes.forEach((prefix) => {
      if(inputIsEnabled(prefix) && clickIsOutsideInput(click, prefix)) {
        // Save input
        // After save, disable/hide input and show display
      }
    })
  })

  inputIdPrefixes.forEach((prefix) => {
    $(`#${prefix}-display`).click(function() {
      matchInputHeightToDisplayElement(prefix, this)
      hideDisplayElement(this)
      showInput(prefix)
    })
  })
});

function matchInputHeightToDisplayElement(prefix, displayElement) {
  $(`#${prefix}-input`).height($(displayElement).height());
}

function hideDisplayElement(displayElement) {
  $(displayElement).hide();
}

function showInput(prefix) {
  $(`#${prefix}-input`).removeClass('d-none');
  $(`#${prefix}-input`).prop('disabled', false)
}

function inputIsEnabled(prefix) {
  return $(`#${prefix}-input`).prop('disabled') === false
}

function clickIsOutsideInput(click, prefix) {
  return click.target.id !== `${prefix}-input`
}
