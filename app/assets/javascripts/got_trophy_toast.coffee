class GotTrophyToast
  constructor: (@$root)->
    this.displayToast()
    return

  displayToast: =>
    trophy = @$root.data().trophy
    user = @$root.data().user
    toastr.success("#{trophy}を獲得しました！", "トロフィー獲得")

    token = $('meta[name="csrf_token"]').attr('content')
    $.ajax(
      url: "/users/got_trophy",
      method: "PATCH",
      data: { authenticity_token: token },
    )
    $('#toast-container').on 'click', ->
      window.location.href = "/#{user}/trophies"

$(document).on "turbolinks:load", ->
  new GotTrophyToast $("#got-trophy-toast") if $("#got-trophy-toast")[0]
