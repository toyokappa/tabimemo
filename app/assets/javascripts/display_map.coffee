class displayMap
  constructor: (@$root)->
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
    latitudes = _.map @$root.find(".spot-latitude"), (lat)=> lat.value
    longitudes = _.map @$root.find(".spot-longitude"), (lng)=> lng.value
    iteration = _.range latitudes.length
    points = _.compact(
      _.map iteration, (i)=> "#{latitudes[i]}, #{longitudes[i]}" unless latitudes[i] == ""
    )

    range = _.range points.length
    positions = _.compact(
      _.map iteration, (i)=> { lat: parseFloat(latitudes[i]), lng: parseFloat(longitudes[i]) } unless latitudes[i] == ""
    )
    labels = _.map @$root.find(".spot-position").not(".deleted"), (position)=> position.value

    if points.length > 1
      @$root.find(".map-rule").hide()
      origin = points.shift()
      destination = points.pop()
      waypoints = _.map points, (point)=> { location: point }

      request =
        origin: origin
        destination: destination
        travelMode: "WALKING"
        waypoints: waypoints

      @directionsService.route request, (result, status)=>
        if status == "OK"
          @directionsRenderer.setDirections(result)
          @directionsRenderer.setMap(@map)
        else
          console.log status

      markers = _.map range, (r)=>
        new google.maps.Marker { position: positions[r], map: @map, label: labels[r] }
    else
      @$root.find(".map-rule").show()
    return

  bind: =>
    @$root.on "change", ".spot-longitude", @setDirection
    return

$(document).on "turbolinks:load", ->
  new displayMap $(".spot-field") unless $(".spot-field").find(".map").val() is undefined
