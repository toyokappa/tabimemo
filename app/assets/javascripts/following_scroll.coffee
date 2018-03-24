class FollowingScroll
  constructor: (@$root)->
    @checkWindowWidth()
    @bind()
    return

  followingScroll: =>
    window_top = $(window).scrollTop() + 95
    $footer = $(".footer")
    target_height = @$root.outerHeight(true)
    target_width = @$root.outerWidth()
    target_top = @$root.offset().top

    if window_top > target_top
      footer_top = $footer.offset().top + 45
      if window_top + target_height > footer_top - 80
        custom_top_position = footer_top - (window_top + target_height)
        @$root.css { position: "fixed", top: "#{custom_top_position}px", width: target_width }
      else
        @$root.css { position: "fixed", top: "80px", width: target_width }
    else
      @$root.css { position: "static", top: "auto", width: "100%" }
    return

  checkWindowWidth: =>
    $(window).off "scroll", @followingScroll
    if $(window).width() >= 1200
      @followingScroll()
      $(window).on "scroll", @followingScroll
    else
      @$root.css { position: "static", top: "auto", width: "100%" }
    return

  bind: =>
    $(window).on "resize", @checkWindowWidth
    return

$(document).on "turbolinks:load", ->
  new FollowingScroll $(".following-scroll") if $(".following-scroll")[0]
