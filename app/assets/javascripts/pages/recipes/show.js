if(typeof isRecipeShow !== 'undefined' && isRecipeShow) {
  const recipeId = $('body').data('params-id');
  let initialInputValue = {}

  $(function() {
    inputIdPrefixes.forEach((prefix) => {
      populateDisplayElement(prefix)
    })

    if(userCanEdit) {
      setPhotoUploader()

      $('#add-ingredient').click(function(click) {
        disableAddIngredient()
      })

      $(document).click(function(click) {
        let noInputWasEnabled = true
        inputIdPrefixes.forEach((prefix) => {
          if(inputIsEnabled(prefix) && clickIsOutsideInput(click, prefix)) {
            click.preventDefault()
            hideInput(prefix)
            populateDisplayElement(prefix)
            showDisplayElement(prefix)
            enableAddIngredient()
            noInputWasEnabled = false
            saveInput(prefix)
            resetInitialInputValue()
          }
        })
        if (noInputWasEnabled) {
          if (favouriteRecipeWasClicked(click)) {
            heartTransplant()
            updateFavourite(click.target.id)
          } else if (deleteIngredientWasClicked(click)) {
            hideIngredient(ingredientIdNumber(click.target.id))
            deleteIngredient(ingredientIdNumber(click.target.id))
          } else {
            inputIdPrefixes.forEach((prefix) => {
              if(click.target.id.includes(`${prefix}-`) && click.target.id.includes('-display')) {
                setInitialInputValue(prefix)
                matchInputHeightToDisplayElement(prefix, click.target)
                hideDisplayElement(click.target)
                showInput(prefix)
                disableAddIngredient()
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

  const heartTransplant = () => $('#full-heart, #empty-heart').toggleClass('d-none')

  function updateFavourite(heart) {
    if (heart === 'full-heart') {
      type = 'delete'
      url = `/recipes/${recipeId}/remove_as_favourite`
    } else {
      type = 'post'
      url = `/recipes/${recipeId}/user_favourite_recipes`
    }
    ajaxRequest(type, url, undefined, undefined, undefined, undefined, undefined, displaySuccess = false, displayFail = false)
  }

  const deleteIngredient = (ingredientId) => ajaxRequest('delete', `/recipes/${recipeId}/ingredients/${ingredientId}`, undefined, undefined, component = 'ingredient', verb = 'delete', ingredientId = ingredientId, displaySuccess = false, displayFail = false)

  function disableAddIngredient() {
    $('#add-ingredient-container').addClass('d-none')
    $('#add-ingredient-container-disabled').removeClass('d-none')
  }

  function enableAddIngredient() {
    $('#add-ingredient-container-disabled').addClass('d-none')
    $('#add-ingredient-container').removeClass('d-none')
  }

  const hideIngredient = (ingredientId) => $(`#ingredient-${ingredientId}-display`).addClass('d-none')

  function saveInput(prefix) {
    let url = ''
    let data = {}
    if(isIngredientPrefix(prefix)) {
      url = `/recipes/${recipeId}/ingredients/${ingredientIdNumber(prefix)}`
      data = { 'ingredient' : ingredientData(prefix) }
      component = 'ingredient'
    } else {
      url = `/recipes/${recipeId}`
      data = { 'recipe' : { [prefix] : $(`#${prefix}-input`).val() } }
      component = 'recipe'
    }
    if(inputHasBeenUpdated(prefix, data) && foodIsPresent(prefix)) {
      ajaxRequest('patch', url, data, prefix, component)
    } else if (newIngredientIsEmpty(prefix)) {
      deleteIngredient(ingredientIdNumber(prefix))
    }
  }

  function ingredientData(prefix) {
    let ingredientObject = {}
    $.each(ingredientColumns, function(_, column) {
      ingredientObject[column] = columnIsOptional(column) ? $(`#${prefix}-${column}-input`)[0].checked : $(`#${prefix}-${column}-input`).val()
    })
    return ingredientObject
  }

  const inputHasBeenUpdated = (prefix, data) => isIngredientPrefix(prefix) ? ingredientHasBeenUpdated(prefix, data) : data.recipe[prefix] != initialInputValue[prefix]

  function ingredientHasBeenUpdated(prefix, data) {
    let changesDetected = false
    $.each(ingredientColumns, function(_, column) {
      if (data.ingredient[column] != initialInputValue[column]) changesDetected = true
    })
    return changesDetected
  }

  function foodIsPresent(prefix) {
    return isIngredientPrefix(prefix) ? !!$(`#${prefix}-food-input`).val().trim() : true
  }

  function newIngredientIsEmpty(prefix) {
    return jQuery.isEmptyObject(initialInputValue) && !foodIsPresent(prefix)
  }

  function ajaxRequest(type, url, data = null, prefix = null, component = 'recipe', verb = 'save', ingredientId = null, displaySuccess = true, displayFail = true) {
    $.ajax({
      type: type,
      url: url,
      dataType: 'json', // If you're having trouble getting a js.erb page to display, try changing this to 'script' (it worked in some now deleted code with dark mode)
      data: data,
      success: function() {
        if (displaySuccess) displayHiddenFlash(`${component.charAt(0).toUpperCase() + component.slice(1)} ${verb}d`, 'success')
        $('#mark-as-complete-button').removeClass('d-none')
      },
      error: function() {
        if (displayFail) displayHiddenFlash(`Unable to ${verb} ${component}`, 'fail')
        if (type === 'delete' && component === 'ingredient') {
          // DO SOMETHING HERE
        } else {
          // DO SOMETHING HERE
        }
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
      ingredientDisplayContent(prefix)
    } else if((prefix === 'name' || prefix === 'process') && !$(`#${prefix}-input`).val()) {
      $(`#${prefix}-display`).text(placeholders[prefix])
    } else {
      $(`#${prefix}-display`).text($(`#${prefix}-input`).val())
    }
  }

  function ingredientDisplayContent(prefix) {
    if (foodIsPresent(prefix)) {
      $.each(ingredientDisplayRows, function(_, column) {
        $(`#${prefix}-${column}-display`).text(ingredientDisplayColumnContent(prefix, column))
      })
    }
  }

  function ingredientDisplayColumnContent(prefix, column) {
    if (columnIsFood(column)) {
      return foodDisplayRow(prefix)
    } else if (columnIsPreparation(column)) {
      return preparationDisplayRow(prefix)
    }
  }

  function foodDisplayRow(prefix) {
    const displayString = `${$(`#${prefix}-amount-input`).val()} ${unitDisplayContent(prefix)} ${$(`#${prefix}-food-input`).val()}`.trim().toLowerCase()
    return displayString.charAt(0).toUpperCase() + displayString.slice(1)
  }

  function unitDisplayContent(prefix) {
    if ($(`#${prefix}-unit-input`).val() === "") return ""
    const amount = $(`#${prefix}-amount-input`).val().toLowerCase()
    if (!amount || amount == '1' || amount == 'one' || amount == 'a' || amount == 'an') {
      return unitsHumanized[$(`#${prefix}-unit-input`).val()]
    } else {
      return unitsPluralized[$(`#${prefix}-unit-input`).val()]
    }
  }

  function preparationDisplayRow(prefix) {
    if (!!preparationText(prefix) || $(`#${prefix}-optional-input`)[0].checked) {
      let displayString = "("
      displayString = displayString.concat(preparationText(prefix))
      if (!!preparationText(prefix) && $(`#${prefix}-optional-input`)[0].checked) displayString = displayString.concat(', ')
      displayString = displayString.concat($(`#${prefix}-optional-input`)[0].checked ? 'optional' : '')
      return displayString.concat(")")
    } else {
      return ''
    }
  }

  const preparationText = (prefix) => $(`#${prefix}-preparation-input`).val()

  function showDisplayElement(prefix) {
    if(!isIngredientPrefix(prefix) || foodIsPresent(prefix)) {
      $(`#${prefix}-display`).removeClass('d-none');
    }
  }

  const setInitialInputValue = (prefix) => isIngredientPrefix(prefix) ? initialIngredientInputValue(prefix) : initialInputValue[prefix] = $(`#${prefix}-input`).val()

  function initialIngredientInputValue(prefix) {
    $.each(ingredientColumns, function(_, column) {
      initialInputValue[column] = ingredientColumnValue(prefix, column)
    })
  }

  function resetInitialInputValue() {
    initialInputValue = {}
  }

  function matchInputHeightToDisplayElement(prefix, clickTarget) {
    if(!isIngredientPrefix(prefix)) {
      $(`#${prefix}-input`).height($(clickTarget).height());
    }
  }

  const hideDisplayElement = (clickTarget) => $(clickTarget).closest('.input-display').addClass('d-none')

  const showInput = (prefix) => isIngredientPrefix(prefix) ? $(`#${prefix}-input`).removeClass('d-none') : $(`#${prefix}-input`).removeClass('d-none').focus(); // Try to get the cursor to appear at the end of the input

  const inputIsEnabled = (prefix) => !$(`#${prefix}-input`).hasClass('d-none')

  function clickIsOutsideInput(click, prefix) {
    return isIngredientPrefix(prefix) ? click.target.id !== `${prefix}-input` && $.inArray(click.target.id, ingredientInputIds(prefix)) === -1 : click.target.id !== `${prefix}-input`
  }

  function ingredientInputIds(prefix) {
    return $.map(ingredientColumns, function(column) {
      return [`${prefix}-${column}-input`, `${prefix}-${column}-input-label`]
    })
  }

  const isIngredientPrefix = (prefix) => prefix.includes('ingredient')

  const favouriteRecipeWasClicked = (click) => click.target.id === 'full-heart' || click.target.id === 'empty-heart'

  const deleteIngredientWasClicked = (click) => click.target.id.includes('ingredient-') && click.target.id.includes('-delete')

  const ingredientIdNumber = (cssId) => cssId.replace(/[^0-9]/g, '')

  const setSpinnerDimensions = () => $(`#spinner`).height($('#photo-container').height()).width($('#photo-container').height());

  const ingredientColumnValue = (prefix, column) => columnIsOptional(column) ? $(`#${prefix}-${column}-input`)[0].checked : $(`#${prefix}-${column}-input`).val()

  const columnIsFood = (column) => column === 'food'
  const columnIsPreparation = (column) => column === 'preparation'
  const columnIsOptional = (column) => column === 'optional'
}
