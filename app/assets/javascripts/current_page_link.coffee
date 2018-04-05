class CurrentSection
  constructor: ->
    @bind()
    return

  setCurrentSection: =>
    scroll_top = $(window).scrollTop() + 110
    $page_link = $(".page-link")
    iteration = _.range $page_link.length
    _.forEach iteration, (i)->
      $section = $($page_link.eq(i).attr("href"))
      top = $section.offset().top
      bottom = top + $section.outerHeight(true)
      if top <= scroll_top && scroll_top < bottom
        unless $page_link.eq(i).hasClass("active")
          $page_link.removeClass("active")
          $page_link.eq(i).addClass("active")
      else
        $page_link.eq(i).removeClass("active")
    return

  bind: =>
    $(window).on "scroll", @setCurrentSection
    return

$(document).on "turbolinks:load", ->
  new CurrentSection if $(".page-link")[0]
