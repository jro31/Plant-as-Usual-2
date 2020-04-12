const inputIdPrefixes = ['name', 'process']
const recipeId = $('body').data('params-id');

$(function() {
  inputIdPrefixes.forEach((prefix) => {
    populateDisplayElement(prefix)
  })

  $(document).click(function(click) {
    let noInputWasEnabled = true
    inputIdPrefixes.forEach((prefix) => {
      if(inputIsEnabled(prefix) && clickIsOutsideInput(click, prefix)) {
        saveInput(prefix)
        hideInput(prefix)
        populateDisplayElement(prefix)
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

function saveInput(prefix) {
  const url = `/recipes/${recipeId}`
  // Read up on if you need to do something here in the event of an error
  $.ajax({
    type: 'patch',
    url: url,
    dataType: 'json',
    data: { 'recipe' : { [prefix] : $(`#${prefix}-input`).val() } }
  });
}

const hideInput = (prefix) => $(`#${prefix}-input`).prop('disabled', true).addClass('d-none');
const populateDisplayElement = (prefix) => $(`#${prefix}-display`).text($(`#${prefix}-input`).val())
const showDisplayElement = (prefix) => $(`#${prefix}-display`).removeClass('d-none');

const matchInputHeightToDisplayElement = (prefix, displayElement) => $(`#${prefix}-input`).height($(displayElement).height());
const hideDisplayElement = (displayElement) => $(displayElement).addClass('d-none');
const showInput = (prefix) => $(`#${prefix}-input`).removeClass('d-none').prop('disabled', false).focus(); // Try to get the cursor to appear at the end of the input

const inputIsEnabled = (prefix) => $(`#${prefix}-input`).prop('disabled') === false
const clickIsOutsideInput = (click, prefix) => click.target.id !== `${prefix}-input`
