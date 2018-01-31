class ToggleStatusLink
  constructor: (@$root)->
    @bind()
    return

  toggleActive: (e)=>
    @$root.find("li a").removeClass("active")
    $(e.target).addClass("active")
    return

  bind: =>
    @$root.on "click", "li a", @toggleActive
    return

$(document).on "turbolinks:load", ->
  new ToggleStatusLink $(".plan-status-menu")
