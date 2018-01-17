class autoCompleteSpot
  constructor: (@$root)->
    @initMap()
    @bind()

  initMap: =>
    @map = new google.maps.Map @$root.find(".map")[0],
      center:
        lat: 36.489471
        lng: 139.000448
      zoom: 6
    return

  suggestSpot: (e)=>
    $target = $(e.target)
    input = $target.val()
    $place_id = $target.closest(".spot-form").find(".place-id")
    @useHtml()
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
              description = description.slice(2) if description.indexOf("日本") == 0
              places.push {place_id: "#{place_id}", label: "<div class='place-title'>#{place}</div><div class='place-description'>#{description}</div>", value: "#{place}"}
            res places
      select: (event, ui)->
        $target.val ui.item.value
        $place_id.val(ui.item.place_id).change()
      autoFocus: true
      delay: 200
    return

  useHtml: ->
    $.ui.autocomplete.prototype._renderItem = (ul, item)->
      return $("<li></li>").data("item.complete", item).append($("<a></a>").html(item.label)).appendTo(ul)

  setGeometry: (e)=>
    $target = $(e.target)
    request = { placeId: $target.val() }
    $spot_form = $target.closest(".spot-form")
    $latitude = $spot_form.find(".spot-latitude")
    $longitude = $spot_form.find(".spot-longitude")
    service = new google.maps.places.PlacesService(@map)
    service.getDetails request, (place, status)=>
      if status == "OK"
        location = place.geometry.location
        $latitude.val location.lat()
        $longitude.val(location.lng()).change()
      else
        console.log status
    return

  bind: =>
    @$root.on "keyup", ".spot-name", @suggestSpot
    @$root.on "change", ".place-id", @setGeometry

$(document).on "turbolinks:load", ->
  new autoCompleteSpot $(".spot-container") unless $(".spot-container").val() is undefined
