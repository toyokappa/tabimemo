class autoCompleteSpot
  constructor: (@$root)->
    @bind()

  setAutoComplete: (e)=>
    target = e.target
    new google.maps.places.Autocomplete target
    return

  bind: =>
    @$root.on "click", ".spot-name", @setAutoComplete

$(document).on "turbolinks:load", ->
  new autoCompleteSpot $(".spot-container")
