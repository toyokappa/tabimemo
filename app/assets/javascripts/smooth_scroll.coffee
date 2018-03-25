class SmoothScroll
  constructor: ->
    @bind()

  scrollTo: (e)->
    e.preventDefault()
    header_height = 100
    hash = this.hash
    $('html, body').animate {
      scrollTop: $(hash).offset().top - header_height
    }, 500, "swing"
    false

  bind: =>
    $(".smooth-scroll").on "click", @scrollTo

$(document).on "turbolinks:load", ->
  new SmoothScroll
