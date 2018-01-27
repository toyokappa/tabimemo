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
    $(".smooth-scroll").on "click", @scrollTo

$(document).on "turbolinks:load", ->
  new SmoothScroll
