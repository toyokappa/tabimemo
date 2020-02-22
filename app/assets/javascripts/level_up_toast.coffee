class LevelUpToast
  constructor: (@$root)->
    this.displayToast()
    return

  displayToast: =>
    level = @$root.data().level
    toastr.success("Lv.#{level}になりました！", "レベルアップ")

    token = $('meta[name="csrf_token"]').attr('content')
    $.ajax(
      url: "/users/level_up",
      method: "PATCH",
      data: { authenticity_token: token },
    )

$(document).on "turbolinks:load", ->
  new LevelUpToast $("#level-up-toast") if $("#level-up-toast")[0]
