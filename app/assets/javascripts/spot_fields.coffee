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
      @$root.find(".spot_field_id").last().val(res)
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

  createPreview: (e) =>
    files = e.target.files
    $parent = $(e.target.parentNode)
    $photo_field = $parent.find(".photo_field").first()
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
    previews = $field.find(".preview")
    for preview in previews
      $(preview).remove()
    return

  bind: =>
    @$root.on "click", ".create_btn", @createSpotField
          .on "click", ".destroy_btn", @destroySpotField
          .on "click", ".destroy_photo_btn", @destroyPhoto
          .on "change", ".preview_photo", @createPreview
    return

$(document).on "turbolinks:load", ->
  new spotFields $(".spot_container")