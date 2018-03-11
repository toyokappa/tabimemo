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
    $spot_form = $target.closest(".spot-form")
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
            places = _.map data, (place)=>
              label: "<div class='place-title'>#{place.name}</div><div class='place-description'>#{place.address}</div>"
              value: place.name
              address: place.address
              lat: place.lat
              lng: place.lng
            res places
      select: (event, ui)->
        $target.val ui.item.value
        $spot_form.find(".spot-address").val ui.item.address
        $spot_form.find(".spot-latitude").val ui.item.lat
        $spot_form.find(".spot-longitude").val(ui.item.lng).change()
      autoFocus: true
    return

  useHtml: ->
    $.ui.autocomplete.prototype._renderItem = (ul, item)->
      return $("<li></li>").data("item.complete", item).append($("<a></a>").html(item.label)).appendTo(ul)

  bind: =>
    @$root.on "keyup", ".spot-name", @suggestSpot

$(document).on "turbolinks:load", ->
  new autoCompleteSpot $(".spot-container") if $(".spot-container")[0]
