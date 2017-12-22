class flashMessage
  constructor: (@$root)->
    @showFlash()

  showFlash: =>
    @$root.unbind("click").click @hideFlash
    @$root.stop()
    height = @$root.outerHeight()
    @$root.css "bottom", -height
    @$root.show()
    @$root.animate({ "bottom": 0 }, 600).delay(5000).animate({ "bottom": -height }, 600).fadeOut(0)
    return

  hideFlash: (e)=>
    $target = $(e.target)
    $target.stop()
    $target.fadeOut 500
    return

$(document).on "turbolinks:load", ->
  new flashMessage $(".flash-message-container")