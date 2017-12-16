class spotFields
  constructor: (@$root)->
    @bind()

  createSpotField: (e)=>
    e.preventDefault()
    $target = $(e.target)
    data = $target.data()
    spot_field = @$root.find(".spot_field")
    time = new Date().getTime()
    regexp = new RegExp(data.id, "g")
    spot_field.append(data.fields.replace(regexp, time))
    return

  destroySpotField: (e)=>
    e.preventDefault()
    $target = $(e.target)
    $spot_form = $target.closest(".spot_form")
    $spot_form.find(".destroy_spot").val(true)
    $spot_form.hide()
    return


  bind: =>
    @$root.on "click", ".create_btn", @createSpotField
          .on "click", ".destroy_btn", @destroySpotField
    return

$(document).on "turbolinks:load", ->
  new spotFields $(".spot_container")