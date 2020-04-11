const inputIdPrefixes = ['name', 'process']

$(function() {
  $(document).click(function(click) {
    inputIdPrefixes.forEach((prefix) => {
      if(inputIsEnabled(prefix) && clickIsOutsideInput(click, prefix)) {
        // Save input

        // After save, disable/hide input and show display
        hideInput(prefix)
        showDisplayElement(prefix)

        // Break loop
        return false
      }
      if(click.target.id === `${prefix}-display`){
        matchInputHeightToDisplayElement(prefix, click.target)
        hideDisplayElement(click.target)
        showInput(prefix)
      }
    })
  })
});

const hideInput = (prefix) => $(`#${prefix}-input`).prop('disabled', true).addClass('d-none');
function showDisplayElement(prefix){
  $(`#${prefix}-display`).removeClass('d-none');
}

const matchInputHeightToDisplayElement = (prefix, displayElement) => $(`#${prefix}-input`).height($(displayElement).height());
const hideDisplayElement = (displayElement) => $(displayElement).addClass('d-none');
const showInput = (prefix) => $(`#${prefix}-input`).removeClass('d-none').prop('disabled', false);

const inputIsEnabled = (prefix) => $(`#${prefix}-input`).prop('disabled') === false
const clickIsOutsideInput = (click, prefix) => click.target.id !== `${prefix}-input`
