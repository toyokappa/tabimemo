class spotFields
  constructor: (@$root)->
    @bind()

  createSpotField: (e)=>
    e.preventDefault()
    $target = $(e.target)
    data = $target.data()
    spot_field = @$root.find(".spot_field")
    $.ajax
      url: "/users/create_spot"
      type: "GET"
      dataType: "json"
      data:
        plan_id: data.planId
    .done (res) =>
      regexp = new RegExp(data.id, "g")
      spot_field.append(data.fields.replace(regexp, res))
    return

  destroySpotField: (e)=>
    e.preventDefault()
    $target = $(e.target)
    $spot_form = $target.closest(".spot_form")
    $spot_form.find(".destroy_spot").val(true)
    $spot_form.hide()
    return

  destroyPhoto: (e)=>
    e.preventDefault()
    $target = $(e.target)
    $photo_area = $target.closest(".photo_area")
    $photo_area.find(".destroy_photo").val(true)
    $photo_area.hide()

  bind: =>
    @$root.on "click", ".create_btn", @createSpotField
          .on "click", ".destroy_btn", @destroySpotField
          .on "click", ".destroy_photo_btn", @destroyPhoto
    return

$(document).on "turbolinks:load", ->
  new spotFields $(".spot_container")