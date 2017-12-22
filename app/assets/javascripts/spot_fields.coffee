class spotFields
  constructor: (@$root)->
    @bind()

  createSpotField: (e)=>
    e.preventDefault()
    $target = $(e.target)
    data = $target.data()
    $spot_field = @$root.find ".spot-field"
    $.get(
      "/users/create_spot"
      plan_id: data.planId
      (res) =>
        regexp = new RegExp data.id, "g"
        $spot_field.append data.fields.replace(regexp, res)
        @$root.find(".spot-field-id").last().val(res)
      "json"
    )
    return

  destroySpotField: (e)=>
    e.preventDefault()
    $target = $(e.target)
    $spot_form = $target.closest ".spot-form"
    $spot_form.find(".destroy-spot").val(true)
    $spot_form.hide()
    return

  destroyPhoto: (e)=>
    e.preventDefault()
    $target = $(e.target)
    $photo_area = $target.closest ".photo-area"
    $photo_area.find(".destroy-photo").val(true)
    $photo_area.hide()

  createPreview: (e) =>
    files = e.target.files
    $parent = $(e.target.parentNode)
    $photo_field = $parent.find(".photo-field").first()
    @resetPreview $photo_field
    for file in files
      reader = new FileReader
      reader.readAsDataURL file
      reader.addEventListener "load", (re) ->
        div = document.createElement "div"
        div.className = "col-sm-4 preview"
        img = document.createElement "img"
        img.src = re.target.result
        div.appendChild img
        $photo_field.append div
    return

  resetPreview: ($field) =>
    previews = $field.find ".preview"
    for preview in previews
      $(preview).remove()
    return

  bind: =>
    @$root.on "click", ".create-spot-btn", @createSpotField
          .on "click", ".destroy-spot-btn", @destroySpotField
          .on "click", ".destroy-photo-btn", @destroyPhoto
          .on "change", ".preview-photo", @createPreview
    return

$(document).on "turbolinks:load", ->
  new spotFields $(".spot-container")