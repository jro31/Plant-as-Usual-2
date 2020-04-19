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
  console.log("🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀")
  console.log(url)
  console.log("🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀")
  ajaxRequest('patch', url, data)
}

const hideInput = (prefix) => $(`#${prefix}-input`).prop('disabled', true).addClass('d-none');

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
    $(`#${prefix}-input`).removeClass('d-none').prop('disabled', false).focus(); // Try to get the cursor to appear at the end of the input
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

function ajaxRequest(type, url, data) {
  // Read up on if you need to do something here in the event of an error
  $.ajax({
    type: type,
    url: url,
    dataType: 'json',
    data: data
  });
}
