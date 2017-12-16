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


  bind: =>
    @$root.on "click", ".create_btn", @createSpotField
          .on "click", ".destroy_btn", @destroySpotField
    return

$(document).on "turbolinks:load", ->
  new spotFields $(".spot_container")