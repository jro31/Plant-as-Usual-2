const inputIdPrefixes = ['name', 'process']

$(function() {
  $(document).click(function(click) {
    let noInputWasEnabled = true
    inputIdPrefixes.forEach((prefix) => {
      if(inputIsEnabled(prefix) && clickIsOutsideInput(click, prefix)) {
        // Save input

        hideInput(prefix)
        showDisplayElement(prefix)
        noInputWasEnabled = false
      }
    })
    inputIdPrefixes.forEach((prefix) => {
      if(click.target.id === `${prefix}-display` && noInputWasEnabled){
        matchInputHeightToDisplayElement(prefix, click.target)
        hideDisplayElement(click.target)
        showInput(prefix)
      }
    })
  })
});

const hideInput = (prefix) => $(`#${prefix}-input`).prop('disabled', true).addClass('d-none');
const showDisplayElement = (prefix) => $(`#${prefix}-display`).removeClass('d-none');

const matchInputHeightToDisplayElement = (prefix, displayElement) => $(`#${prefix}-input`).height($(displayElement).height());
const hideDisplayElement = (displayElement) => $(displayElement).addClass('d-none');
const showInput = (prefix) => $(`#${prefix}-input`).removeClass('d-none').prop('disabled', false);

const inputIsEnabled = (prefix) => $(`#${prefix}-input`).prop('disabled') === false
const clickIsOutsideInput = (click, prefix) => click.target.id !== `${prefix}-input`
