const recipeId = $('body').data('params-id');

console.log(inputIdPrefixes)

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
  if(isIngredientPrefix(prefix)) {
    let url = `/recipes/${recipeId}/ingredients/${prefix.replace('ingredient-', '')}`
    let data = 'coming_soon' // START HERE NEXT TIME
  } else {
    let url = `/recipes/${recipeId}`
    let data = { 'recipe' : { [prefix] : $(`#${prefix}-input`).val() } }
    ajaxRequest('patch', url, data) // MOVE THIS TO THE LINE BELOW ONCE data IS SET ON LINE 34
  }
  // ajaxRequest('patch', url, data)
}

const hideInput = (prefix) => $(`#${prefix}-input`).prop('disabled', true).addClass('d-none');

function populateDisplayElement(prefix) {
  if(isIngredientPrefix(prefix)) {
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
  if(isIngredientPrefix(prefix)) {

  } else {
    $(`#${prefix}-input`).height($(clickTarget).height());
  }
}

const hideDisplayElement = (clickTarget) => $(clickTarget).closest('.input-display').addClass('d-none')
function showInput(prefix){
  if(isIngredientPrefix(prefix)) {
    $(`#${prefix}-input`).removeClass('d-none')
  } else {
    $(`#${prefix}-input`).removeClass('d-none').prop('disabled', false).focus(); // Try to get the cursor to appear at the end of the input
  }
}

const inputIsEnabled = (prefix) => !$(`#${prefix}-input`).hasClass('d-none')
const clickIsOutsideInput = (click, prefix) => click.target.id !== `${prefix}-input`

const isIngredientPrefix = (prefix) => prefix.includes('ingredient')

function ajaxRequest(type, url, data) {
  // Read up on if you need to do something here in the event of an error
  $.ajax({
    type: type,
    url: url,
    dataType: 'json',
    data: data
  });
}
