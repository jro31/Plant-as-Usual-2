const recipeId = $('body').data('params-id');

console.log(inputIdPrefixes)
console.log(ingredientElementPrefixes)

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
      if(click.target.id.includes(prefix) && click.target.id.includes('-display') && noInputWasEnabled){
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

function populateDisplayElement(prefix) {
  if(prefix.includes('ingredient')) {
    $(`#${prefix}-amount-display`).text($(`#${prefix}-amount-input`).val())
    $(`#${prefix}-unit-display`).text($(`#${prefix}-unit-input`).val())
    $(`#${prefix}-name-display`).text($(`#${prefix}-name-input`).val())
    $(`#${prefix}-preparation-display`).text($(`#${prefix}-preparation-input`).val())
  } else {
    $(`#${prefix}-display`).text($(`#${prefix}-input`).val())
  }
}

const showDisplayElement = (prefix) => $(`#${prefix}-display`).removeClass('d-none');

function matchInputHeightToDisplayElement(prefix, clickTarget) {
  if(prefix.includes('ingredient')) {

  } else {
    $(`#${prefix}-input`).height($(clickTarget).height());
  }
}

function hideDisplayElement(clickTarget){
  $(clickTarget).closest('.input-display').addClass('d-none')
}
const showInput = (prefix) => $(`#${prefix}-input`).removeClass('d-none').prop('disabled', false).focus(); // Try to get the cursor to appear at the end of the input

const inputIsEnabled = (prefix) => $(`#${prefix}-input`).prop('disabled') === false
const clickIsOutsideInput = (click, prefix) => click.target.id !== `${prefix}-input`
