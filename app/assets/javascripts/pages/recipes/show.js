if(typeof isRecipeShow !== 'undefined' && isRecipeShow) {
  const recipeId = $('body').data('params-id');
  let initialInputValue = {}

  $(function() {
    inputIdPrefixes.forEach((prefix) => {
      populateDisplayElement(prefix)
    })

    if(userCanEdit) {
      setPhotoUploader()

      $(document).click(function(click) {
        let noInputWasEnabled = true
        inputIdPrefixes.forEach((prefix) => {
          if(inputIsEnabled(prefix) && clickIsOutsideInput(click, prefix)) {
            click.preventDefault()
            saveInput(prefix)
            hideInput(prefix) // Should this rest of this method be called from the 'success' of the Ajax request instead of here?
            populateDisplayElement(prefix)
            showDisplayElement(prefix)
            resetInitialInputValue()
            noInputWasEnabled = false
          }
        })
        if (noInputWasEnabled) {
          if (deleteIngredientWasClicked(click)) {
            deleteIngredient(ingredientIdNumber(click.target.id))
            hideIngredient(ingredientIdNumber(click.target.id)) // Should this rest of this method be called from the 'success' of the Ajax request instead of here?
          } else {
            inputIdPrefixes.forEach((prefix) => {
              if(click.target.id.includes(prefix) && click.target.id.includes('-display')){
                setInitialInputValue(prefix)
                matchInputHeightToDisplayElement(prefix, click.target)
                hideDisplayElement(click.target)
                showInput(prefix)
              }
            })
          }
        }
      })
    }
  });

  function setPhotoUploader() {
    $('#photo-uploader').change(function() {
      $('#spinner').removeClass('d-none');
      $('#submit-photo').click()
    })

    $('#photo-container').click(function() { // Update this so only the photo is clickable. Having the whole row clickable is a bit annoying when clicking to close the navbar dropdown
      $('#photo-uploader').click()
    })
    setSpinnerDimensions()
  }

  const deleteIngredient = (ingredientId) => ajaxRequest('delete', `/recipes/${recipeId}/ingredients/${ingredientId}`, undefined, component = 'ingredient', verb = 'delete')

  const hideIngredient = (ingredientId) => $(`#ingredient-${ingredientId}-display`).addClass('d-none')

  function saveInput(prefix) {
    let url = ''
    let data = {}
    if(isIngredientPrefix(prefix)) {
      url = `/recipes/${recipeId}/ingredients/${ingredientIdNumber(prefix)}`
      data = { 'ingredient' : {
        'amount' : $(`#${prefix}-amount-input`).val(),
        'unit' : $(`#${prefix}-unit-input`).val(),
        'food' : $(`#${prefix}-food-input`).val(),
        'preparation' : $(`#${prefix}-preparation-input`).val(),
      } }
      component = 'ingredient'
    } else {
      url = `/recipes/${recipeId}`
      data = { 'recipe' : { [prefix] : $(`#${prefix}-input`).val() } }
      component = 'recipe'
    }
    if(inputHasBeenUpdated(prefix, data)) {
      ajaxRequest('patch', url, data, component)
    }
  }

  function inputHasBeenUpdated(prefix, data) {
    if(isIngredientPrefix(prefix)) {
      return data.ingredient.amount != initialInputValue.amount || data.ingredient.unit != initialInputValue.unit || data.ingredient.food != initialInputValue.food || data.ingredient.preparation != initialInputValue.preparation
    } else {
      return data.recipe[prefix] != initialInputValue[prefix]
    }
  }

  function ajaxRequest(type, url, data = null, component = 'recipe', verb = 'save') {
    // Read up on if you need to do something here in the event of an error
    $.ajax({
      type: type,
      url: url,
      dataType: 'json', // If you're having trouble getting a js.erb page to display, try changing this to 'script' (it worked in some now deleted code with dark mode)
      data: data,
      success: function() {
        displayHiddenFlash(`${component.charAt(0).toUpperCase() + component.slice(1)} ${verb}d`, 'success')
        $('#mark-as-complete-button').removeClass('d-none')
      },
      error: function() {
        displayHiddenFlash(`Unable to ${verb} ${component}`, 'fail')
      }
    });
  }

  function displayHiddenFlash(text, status) {
    $('#hidden-flash-text').text(text)
    $('#hidden-flash-message').addClass(status).fadeIn(1000)
    setTimeout(function() {
      $('#hidden-flash-message').fadeOut(1000, function() {
        $('#hidden-flash-message').removeClass(status)
      })
    }, 3000);
  }

  const hideInput = (prefix) => $(`#${prefix}-input`).addClass('d-none');

  function populateDisplayElement(prefix) {
    if(isIngredientPrefix(prefix)) {
      $(`#${prefix}-amount-display`).text($(`#${prefix}-amount-input`).val())
      $(`#${prefix}-unit-display`).text($(`#${prefix}-unit-input`).val())
      $(`#${prefix}-food-display`).text($(`#${prefix}-food-input`).val())
      $(`#${prefix}-preparation-display`).text(preparationText(prefix))
    } else if((prefix === 'name' || prefix === 'process') && !$(`#${prefix}-input`).val()) {
      $(`#${prefix}-display`).text(placeholders[prefix])
    } else {
      $(`#${prefix}-display`).text($(`#${prefix}-input`).val())
    }
  }

  const preparationText = (prefix) => $(`#${prefix}-preparation-input`).val() == '' ? '' : `(${$(`#${prefix}-preparation-input`).val()})`

  const showDisplayElement = (prefix) => $(`#${prefix}-display`).removeClass('d-none');

  function setInitialInputValue(prefix) {
    if(isIngredientPrefix(prefix)) {
      initialInputValue['amount'] = $(`#${prefix}-amount-input`).val()
      initialInputValue['unit'] = $(`#${prefix}-unit-input`).val()
      initialInputValue['food'] = $(`#${prefix}-food-input`).val()
      initialInputValue['preparation'] = $(`#${prefix}-preparation-input`).val()
    } else {
      initialInputValue[prefix] = $(`#${prefix}-input`).val()
    }
  }

  function resetInitialInputValue() {
    initialInputValue = {}
  }

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

  const ingredientIdNumber = (cssId) => cssId.replace(/[^0-9]/g, '')

  const setSpinnerDimensions = () => $(`#spinner`).height($('#photo-container').height()).width($('#photo-container').height());
}
