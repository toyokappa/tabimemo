class SmoothScroll
  constructor: ->
    @bind()

  scrollTo: (e)->
    e.preventDefault()
    hash = this.hash
    $('html, body').animate {
      scrollTop: $(hash).offset().top
    }, 500, "swing"
    false

  bind: =>
    $("a[href^='#']").on "click", @scrollTo

$(document).on "turbolinks:load", ->
  new SmoothScroll
