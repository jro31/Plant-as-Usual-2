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
        hideInput(prefix) // Should this rest of this method be called from the 'success' of the Ajax request instead of here?
        populateDisplayElement(prefix)
        showDisplayElement(prefix)
        noInputWasEnabled = false
      }
    })
    if (noInputWasEnabled) {
      if (deleteIngredientWasClicked(click)) {
        deleteIngredient(click.target.id.replace('ingredient-', '').replace('-delete', ''))
        hideIngredient(click.target.id.replace('ingredient-', '').replace('-delete', '')) // Should this rest of this method be called from the 'success' of the Ajax request instead of here?
      } else {
        inputIdPrefixes.forEach((prefix) => {
          if(click.target.id.includes(prefix) && click.target.id.includes('-display')){
            matchInputHeightToDisplayElement(prefix, click.target)
            hideDisplayElement(click.target)
            showInput(prefix)
          }
        })
      }
    }
  })
});

const deleteIngredient = (ingredientId) => ajaxRequest('delete', `/recipes/${recipeId}/ingredients/${ingredientId}`)

const hideIngredient = (ingredientId) => $(`#ingredient-${ingredientId}-display`).addClass('d-none')

function saveInput(prefix) {
  let url = ''
  let data = {}
  if(isIngredientPrefix(prefix)) {
    url = `/recipes/${recipeId}/ingredients/${prefix.replace('ingredient-', '')}`
    data = { 'ingredient' : {
      'amount' : $(`#${prefix}-amount-input`).val(),
      'unit' : $(`#${prefix}-unit-input`).val(),
      'food' : $(`#${prefix}-food-input`).val(),
      'preparation' : $(`#${prefix}-preparation-input`).val(),
    } }
  } else {
    url = `/recipes/${recipeId}`
    data = { 'recipe' : { [prefix] : $(`#${prefix}-input`).val() } }
  }
  ajaxRequest('patch', url, data)
}


function ajaxRequest(type, url, data = null) {
  // Read up on if you need to do something here in the event of an error
  $.ajax({
    type: type,
    url: url,
    dataType: 'json',
    data: data
  });
}

const hideInput = (prefix) => $(`#${prefix}-input`).addClass('d-none');

function populateDisplayElement(prefix) {
  if(isIngredientPrefix(prefix)) {
    $(`#${prefix}-amount-display`).text($(`#${prefix}-amount-input`).val())
    $(`#${prefix}-unit-display`).text($(`#${prefix}-unit-input`).val())
    $(`#${prefix}-food-display`).text($(`#${prefix}-food-input`).val())
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
    $(`#${prefix}-input`).removeClass('d-none').focus(); // Try to get the cursor to appear at the end of the input
  }
}

const inputIsEnabled = (prefix) => !$(`#${prefix}-input`).hasClass('d-none')

function clickIsOutsideInput(click, prefix) {
  if(isIngredientPrefix(prefix)) {
    return click.target.id !== `${prefix}-input` && click.target.id !== `${prefix}-amount-input` && click.target.id !== `${prefix}-unit-input` && click.target.id !== `${prefix}-food-input` && click.target.id !== `${prefix}-preparation-input`
  } else {
    return click.target.id !== `${prefix}-input`
  }
}

const isIngredientPrefix = (prefix) => prefix.includes('ingredient')

const deleteIngredientWasClicked = (click) => click.target.id.includes('ingredient-') && click.target.id.includes('-delete')

// To do next:
// Give ingredients a 'delete' button
// Sort photo upload
