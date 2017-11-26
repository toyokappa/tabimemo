class previewImages
  constructor: (@$root) ->
    console.log 'a'
    @bind()

  bind: =>
    @$root.on 'change', '.photos', @createPreview
    return

  createPreview: (e) =>
    console.log 'b'
    files = e.target.files
    parent = e.target.parentNode
    @resetPreview(parent)
    for file in files
      reader = new FileReader()
      reader.readAsDataURL file
      reader.addEventListener 'load', (re) ->
        li = document.createElement 'li'
        li.className = 'preview'
        img = document.createElement 'img'
        img.src = re.target.result
        li.appendChild img
        parent.querySelector('.photo_area').appendChild(li)
    return

  resetPreview: (parent) =>
    previews = $(parent).find '.preview'
    for preview in previews
      $(preview).remove()
    return

$(window).load ->
  new previewImages($('.spot_container'))