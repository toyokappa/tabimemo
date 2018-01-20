class spotFields
  constructor: (@$root)->
    @bind()

  createSpotField: (e)=>
    e.preventDefault()
    $target = $(e.target)
    data = $target.data()
    $.get(
      "/users/create_spot"
      plan_id: data.planId
      (res) =>
        regexp = new RegExp data.id, "g"
        $target.before data.fields.replace(regexp, res)
        @$root.find(".spot-field-id").last().val(res)
        new google.maps.Map @$root.find(".preview-maps").last()[0],
          center:
            lat: 36.489471
            lng: 139.000448
          zoom: 6
      "json"
    )
    return

  destroySpotField: (e)=>
    e.preventDefault()
    $target = $(e.target)
    $spot_form = $target.closest ".spot-form"
    $spot_form.find(".spot-destory").val(true)
    $spot_form.find(".spot-latitude").val("")
    $spot_form.find(".spot-longitude").val("").change()
    $spot_form.hide()
    return

  destroyPhoto: (e)=>
    e.preventDefault()
    $target = $(e.target)
    $photo_area = $target.closest ".photo-area"
    $photo_area.find(".photo-destroy").val(true)
    $photo_area.hide()

  openFileField: (e)=>
    $(e.target).closest(".photo-field").find(".spot-photos").click()
    return

  createPhotos: (e)=>
    $target = $(e.target)
    $spot_form = $target.closest ".spot-form"
    $photo_loading = $spot_form.find ".photo-loading"
    data = $target.data()
    formData = new FormData()
    deferred_list = []
    error_messages = []
    $photo_loading.show()
    formData.append("spot_id", $spot_form.find(".spot-field-id").val())
    _.forEach $target.prop("files"), (file)=>
      formData.append("photo[image]", file)
      $ajax = @deferAjax(
        type: "POST"
        url: "/users/photos"
        data: formData
        processData: false
        contentType: false
        dataType: "json"
      )
      .done (res, status)=>
        if status is "success"
          regexp = new RegExp data.id, "g"
          $fragment = $(document.createDocumentFragment())
          $fragment.append data.fields.replace(regexp, res.id)
          $fragment.find(".photo-id").val res.id
          $fragment.find(".preview-photo").attr("src", res.image.thumb.url)
          $photo_loading.before $fragment
        else
          error_messages.push res.responseJSON[0]
      deferred_list.push $ajax
    $.when.apply(null, deferred_list).done ()=>
      $photo_loading.hide()
      if error_messages.length > 0
        console.log _.countBy error_messages

  deferAjax: (opt)=>
    $ajax = $.ajax(opt)
    $defer = new $.Deferred()
    $ajax.done (data, status, $ajax)=>
      $defer.resolveWith this, arguments
    $ajax.fail (data, status, $ajax)=>
      $defer.resolveWith this, arguments
    return $.extend {}, $ajax, $defer.promise()

  bind: =>
    @$root.on "click", ".create-spot-btn", @createSpotField
          .on "click", ".destroy-spot-btn", @destroySpotField
          .on "click", ".destroy-photo-btn", @destroyPhoto
          .on "click", ".add-photos", @openFileField
          .on "change", ".spot-photos", @createPhotos
    return

$(document).on "turbolinks:load", ->
  new spotFields $(".spot-container")
