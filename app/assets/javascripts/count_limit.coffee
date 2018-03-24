class CountLimit
  constructor: (@$root)->
    @bind()
    return

  countLimit: (e)=>
    $target = $(e.target)
    $limit_field = $target.closest(".form-group").find(".limit-field")
    limit = $target.data().limit
    count = $target.val().length
    $limit_field.find(".limit-value").text(limit - count)
    if (limit - count) < 0
      $limit_field.addClass("text-danger") unless $limit_field.hasClass("text-danger")
    else
      $limit_field.removeClass("text-danger")
    return

  bind: =>
    @$root.on "keyup", ".limit-target", @countLimit
    return

$(document).on "turbolinks:load", ->
  new CountLimit $(".form-with-limit") if $(".form-with-limit")[0]
