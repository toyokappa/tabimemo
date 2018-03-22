class FollowingScroll
  constructor: ->
    @bind()
    return

  followingScroll: =>
    window_top = $(window).scrollTop() + 95
    target = $(".following-scroll")
    footer = $(".footer")
    target_height = target.outerHeight(true)
    target_width = target.outerWidth()
    target_top = target.offset().top

    if window_top > target_top
      footer_top = footer.offset().top + 45
      if window_top + target_height > footer_top - 80
        custom_top_position = footer_top - (window_top + target_height)
        target.css { position: "fixed", top: "#{custom_top_position}px", width: target_width }
      else
        target.css { position: "fixed", top: "80px", width: target_width }
    else
      target.css { position: "static", top: "auto" }
    return

  bind: =>
    $(window).on "scroll", @followingScroll
    return

$(document).on "turbolinks:load", ->
  new FollowingScroll if $(".following-scroll")[0]
