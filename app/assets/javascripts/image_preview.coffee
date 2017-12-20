class previewImages
  constructor: (@$root) ->
    @bind()

  bind: =>
    @$root.on "change", ".images", @createPreview
    return

  createPreview: (e) =>
    files = e.target.files
    parent = e.target.parentNode
    @resetPreview parent
    for file in files
      reader = new FileReader
      reader.readAsDataURL file
      reader.addEventListener "load", (re) ->
        div = document.createElement "div"
        div.className = "preview"
        img = document.createElement "img"
        img.src = re.target.result
        div.appendChild img
        parent.insertBefore div, e.target
    return

  resetPreview: (parent) =>
    previews = $(parent).find ".preview"
    for preview in previews
      $(preview).remove()
    return

$(document).on "turbolinks:load", ->
  new previewImages $(".image-field")
