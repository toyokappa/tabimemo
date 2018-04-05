class FollowingScroll
  constructor: (@$root)->
    @target_top = @$root.closest(".row").offset().top + 30
    @checkWindowWidth()
    @bind()
    return

  followingScroll: =>
    window_top = $(window).scrollTop() + 110
    $footer = $(".footer")

    if window_top > @target_top
      footer_top = $footer.offset().top
      if window_top + @target_height > footer_top - 80
        custom_top_position = footer_top - (window_top + @target_height)
        @$root.css { position: "fixed", top: "#{custom_top_position}px", width: @target_width }
      else
        @$root.css { position: "fixed", top: "80px", width: @target_width }
    else
      @$root.css { position: "static", top: "auto", width: "100%" }
    return

  checkWindowWidth: =>
    $(window).off "scroll", @followingScroll
    if $(window).width() >= 992
      @target_height = @$root.outerHeight(true)
      @target_width = @$root.closest(".sidebar").width()
      @$root.css { width: @target_width }
      $(window).on "scroll", @followingScroll
    else
      @$root.css { position: "static", top: "auto", width: "100%" }
    return

  bind: =>
    $(window).on "resize", @checkWindowWidth
    return

$(document).on "turbolinks:load", ->
  new FollowingScroll $(".following-scroll") if $(".following-scroll")[0]
