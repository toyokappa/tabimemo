class OpenNewWindow
  constructor: (@$root)->
    @bind()
    return

  openNewWindow: (e)=>
    e.preventDefault()
    window.open(e.target.href, "sns_window", "width=600, height=500, menubar=no, toolbar=no, scrollbars=yes")
    return

  bind: =>
    @$root.on "click", ".open-new-window", @openNewWindow
    return

$(document).on "turbolinks:load", ->
  new OpenNewWindow $(".set-open-new-window") if $(".set-open-new-window")[0]
