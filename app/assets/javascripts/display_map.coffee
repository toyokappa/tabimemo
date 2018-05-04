class displayMap
  constructor: (@$root)->
    @map = {}
    @markers = []
    @directionsService = new google.maps.DirectionsService()
    @directionsRenderer = new google.maps.DirectionsRenderer(suppressMarkers: true)
    @initMap()
    @bind()

  initMap: =>
    @map = new google.maps.Map @$root.find(".map")[0],
      center:
        lat: 36.489471
        lng: 139.000448
      zoom: 6
    @setDirection()
    return

  setDirection: =>
    @resetMarkers()
    latitudes = _.map @$root.find(".spot-latitude"), (lat)=> lat.value
    longitudes = _.map @$root.find(".spot-longitude"), (lng)=> lng.value
    iteration = _.range latitudes.length
    locations = _.compact(
      _.map iteration, (i)=> "#{latitudes[i]}, #{longitudes[i]}" unless latitudes[i] == ""
    )

    positions = _.compact(
      _.map iteration, (i)=> { lat: parseFloat(latitudes[i]), lng: parseFloat(longitudes[i]) } unless latitudes[i] == ""
    )
    labels = _.map @$root.find(".spot-position").not(".deleted"), (position)=> position.value

    if locations.length > 1
      @$root.find(".map-rule").hide()
      origin = locations.shift()
      destination = locations.pop()
      waypoints = _.map locations, (location)=> { location: location }

      request =
        origin: origin
        destination: destination
        travelMode: "WALKING"
        waypoints: waypoints

      @directionsService.route request, (result, status)=>
        if status == "OK"
          @directionsRenderer.setDirections(result)
          @directionsRenderer.setMap(@map)
        else if status == "ZERO_RESULTS"
          min_lat = parseFloat _.min(latitudes)
          min_lng = parseFloat _.min(longitudes)
          max_lat = parseFloat _.max(latitudes)
          max_lng = parseFloat _.max(longitudes)
          mid_lat = (min_lat + max_lat) / 2.0
          mid_lng = (min_lng + max_lng) / 2.0
          min_bounds = new google.maps.LatLng min_lat, min_lng
          max_bounds = new google.maps.LatLng max_lat, max_lng
          center_position = new google.maps.LatLng mid_lat, mid_lng
          @map.setCenter center_position
          @map.fitBounds new google.maps.LatLngBounds(min_bounds, max_bounds)
          @$root.find(".no-routes").show()
        else
          console.log status

      range = _.range positions.length
      @markers = _.map range, (r)=>
        new google.maps.Marker { position: positions[r], map: @map, label: labels[r] }
    else
      @$root.find(".map-rule").show()
    return

  resetMarkers: =>
    _.forEach @markers, (marker)=>
      marker.setMap(null)

  bind: =>
    @$root.on "change", ".spot-longitude", @setDirection
    return

$(document).on "turbolinks:load", ->
  new displayMap $(".spot-field") unless $(".spot-field").find(".map").val() is undefined
