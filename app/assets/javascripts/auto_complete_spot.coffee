class AutoCompleteSpot
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
    $spot_form = $target.closest(".spot-form")
    service = new google.maps.places.PlacesService(@map)
    @useHtml()
    $target.autocomplete
      source: (req, res)->
        getPredictions(input).done (data)->
          places = _.map data, (place)->
            address = place.address
            address = address.slice(3) if address.indexOf("日本、") == 0
            label: "<div class='place-title'>#{place.name}</div><div class='place-description'>#{address}</div>"
            place_id: place.place_id
            value: place.name
            address: address
          res places
      select: (event, ui)->
        $target.val ui.item.value
        $spot_form.find(".place-id").val(ui.item.place_id).change()
        $spot_form.find(".spot-address").val ui.item.address
      autoFocus: true
      delay: 200
    return

  getPredictions = (input)->
    defer = $.Deferred()
    $.ajax
      url: "/users/suggest_spot"
      type: "GET"
      data:
        input: input
      dataType: "json"
      success: defer.resolve
    return defer.promise()

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

  useHtml: ->
    $.ui.autocomplete.prototype._renderItem = (ul, item)->
      return $("<li></li>").data("item.complete", item).append($("<a></a>").html(item.label)).appendTo(ul)

  bind: =>
    @$root.on "keyup", ".spot-name", @suggestSpot
    @$root.on "change", ".place-id", @setGeometry

$(document).on "turbolinks:load", ->
  new AutoCompleteSpot $(".spot-container") if $(".spot-container")[0]
