class autoCompleteSpot
  constructor: (@$root)->
    @bind()

  suggestSpot: (e)=>
    $target = $(e.target)
    input = $target.val()
    $place_id = $target.closest(".spot-form").find(".place-id")
    $target.autocomplete
      source: (req, res)->
        $.ajax
          url: "/users/suggest_spot"
          type: "GET"
          data:
            input: input
          dataType: "json"
          success: (data)=>
            places = []
            for prediction in data.predictions
              place_id = prediction.place_id
              place = prediction.structured_formatting.main_text
              description = prediction.structured_formatting.secondary_text
              places.push {place_id: "#{place_id}", label: "#{place} -#{description}", value: "#{place}"}
            res places
      select: (event, ui)->
        $target.val ui.item.value
        $place_id.val(ui.item.place_id).change()
      autoFocus: true
      delay: 200
    return

  setGeometry: (e)=>
    $target = $(e.target)
    place_id = $target.val()
    $spot_form = $target.closest(".spot-form")
    $latitude = $spot_form.find(".spot-latitude")
    $longitude = $spot_form.find(".spot-longitude")
    $.ajax
      url: "/users/set_geometry"
      type: "GET"
      data:
        place_id: place_id
      dataType: "json"
      success: (data)=>
        location = data.result.geometry.location
        console.log location
        $latitude.val location.lat
        $longitude.val location.lng
    return

  bind: =>
    @$root.on "keyup", ".spot-name", @suggestSpot
    @$root.on "change", ".place-id", @setGeometry

$(document).on "turbolinks:load", ->
  new autoCompleteSpot $(".spot-container")
