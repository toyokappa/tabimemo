class RotateMenuVector
  constructor: (@$root)->
    @bind()
    return

  rotateMenuVector: =>
    $vector = @$root.find(".menu-vector")
    console.log $vector
    $vector.toggleClass("rotate-vector")
    return

  bind: =>
    @$root.on "click", ".menu-btn", @rotateMenuVector
    return

$(document).on "turbolinks:load", ->
  new RotateMenuVector $(".navbar-header")
