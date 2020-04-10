const inputIdPrefixes = ['name', 'process']

$(function() {
  $(document).click(function(click) {
    inputIdPrefixes.forEach((prefix) => {
      if(inputIsEnabled(prefix) && clickIsOutsideInput(click, prefix)) {
        // Save input
        // After save, disable/hide input and show display
        // Break loop
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

const matchInputHeightToDisplayElement = (prefix, displayElement) => $(`#${prefix}-input`).height($(displayElement).height());
const hideDisplayElement = (displayElement) => $(displayElement).hide();
const showInput = (prefix) => $(`#${prefix}-input`).removeClass('d-none').prop('disabled', false);
const inputIsEnabled = (prefix) => $(`#${prefix}-input`).prop('disabled') === false
const clickIsOutsideInput = (click, prefix) => click.target.id !== `${prefix}-input`
