class displayMap
  constructor: (@$root)->
    @initMap()

  initMap: =>
    map = new google.maps.Map @$root.find(".map")[0],
      center:
        lat: 36.489471
        lng: 139.000448
      zoom: 6
    @setDirection(map)
    return

  setDirection: (map)=>
    directionsService = new google.maps.DirectionsService()
    directionsRenderer = new google.maps.DirectionsRenderer()
    origin = new google.maps.LatLng(@$root.find(".first-spot-latitude").val(), @$root.find(".first-spot-longitude").val())
    destination = new google.maps.LatLng(@$root.find(".last-spot-latitude").val(), @$root.find(".last-spot-longitude").val())
    latitudes = _.map @$root.find(".spot-latitude"), (lat)=> lat.value
    longitudes = _.map @$root.find(".spot-longitude"), (lng)=> lng.value
    iteration = _.range latitudes.length
    waypoints = _.map iteration, (i)=> { location: "#{latitudes[i]}, #{longitudes[i]}" }
    request =
      origin: origin
      destination: destination
      travelMode: "WALKING"
      waypoints: waypoints
    directionsService.route request, (result, status)->
      if status == "OK"
        directionsRenderer.setDirections(result)
        directionsRenderer.setMap(map)
    return

$(document).on "turbolinks:load", ->
  new displayMap $(".spot-field")
