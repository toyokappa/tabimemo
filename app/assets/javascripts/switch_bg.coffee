class SwitchBg
  constructor: (@$root)->
    @switchBackground()

  switchBackground: =>
    speed = 1500
    interval = 6000
    slides = @$root.find(".slide")
    count = 0
    setInterval ()=>
      $(slides[count]).css({ "z-index": -1 }).fadeOut speed
      count = if count == slides.length - 1 then 0 else count + 1
      $(slides[count]).css({ "z-index": -2 }).show()
    , interval
    return

$(document).on "turbolinks:load", ->
  new SwitchBg $(".page-top")
