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
    ini_lats = @$root.find(".spot-latitude")
    ini_lngs = @$root.find(".spot-longitude")
    latitudes = _.map ini_lats, (lat)=> lat.value
    longitudes = _.map ini_lngs, (lng)=> lng.value
    iteration = _.range latitudes.length
    points = _.map iteration, (i)=> new google.maps.LatLng(latitudes[i], longitudes[i])
    request =
      origin: _.head points
      destination: _.last points
      travelMode: "WALKING"
    directionsService.route request, (result, status)->
      directionsRenderer.setDirections(result)
      directionsRenderer.setMap(map)
    return

$(document).on "turbolinks:load", ->
  new displayMap $(".spot-field")
