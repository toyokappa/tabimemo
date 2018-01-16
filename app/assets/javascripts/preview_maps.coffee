class PreviewMaps
  constructor: (@$root)->
    @initMaps()
    @bind()

  initMaps: =>
    $previews = @$root.find(".preview-maps")
    maps = _.map $previews, (preview)=>
      new google.maps.Map preview,
        center:
          lat: 36.489471
          lng: 139.000448
        zoom: 6

    latitudes = _.map @$root.find(".spot-latitude"), (lat)=> parseFloat lat.value
    longitudes = _.map @$root.find(".spot-longitude"), (lng)=> parseFloat lng.value
    iteration = _.range latitudes.length
    positions = _.map iteration, (i)=> if latitudes[i] == "" then null else { lat: latitudes[i], lng: longitudes[i] }
    markers = _.map positions, (position)=>
      new google.maps.Marker { position: position }

    _.forEach iteration, (i)=>
      markers[i].setMap maps[i]
      unless isNaN markers[i].getPosition().lat()
        maps[i].setZoom 16
        maps[i].setCenter markers[i].getPosition()
    return

  changeMarker: (e)=>
    unless e.target.value == ""
      $target = $(e.target)
      lat = parseFloat $target.parent().find(".spot-latitude").val()
      lng = parseFloat $target.val()
      $preview = $target.parent().find(".preview-maps")
      map = new google.maps.Map $preview[0],
        center:
          lat: lat
          lng: lng
        zoom: 16
      position = { lat: lat, lng: lng }
      marker = new google.maps.Marker { position: position, map: map }
    return

  bind: =>
    @$root.on "change", ".spot-longitude", @changeMarker

$(document).on "turbolinks:load", ->
  new PreviewMaps $(".spot-container") unless $(".spot-container").val() is undefined
