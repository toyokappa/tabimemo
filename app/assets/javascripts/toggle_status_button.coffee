class ToggleStatusButton
  constructor: (@$root)->
    @bind()
    return

  setPublished: =>
    @$root.closest(".menu-box-footer").find(".published-btn").show()
    @$root.find(".set-published .toggle-check").show()
    @$root.find(".toggle-menu").css { left: "-120px" }
    @$root.closest(".menu-box-footer").find(".draft-btn").hide()
    @$root.find(".set-draft .toggle-check").hide()
    return

  setDraft: =>
    @$root.closest(".menu-box-footer").find(".draft-btn").show()
    @$root.find(".set-draft .toggle-check").show()
    @$root.find(".toggle-menu").css { left: "-132px" }
    @$root.closest(".menu-box-footer").find(".published-btn").hide()
    @$root.find(".set-published .toggle-check").hide()
    return

  bind: =>
    @$root.on "click", ".set-published", @setPublished
          .on "click", ".set-draft", @setDraft
    return

$(document).on "turbolinks:load", ->
  new ToggleStatusButton $(".toggle-status") if (".toggle-status")[0]
