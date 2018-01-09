class autoCompleteSpot
  constructor: (@$root)->
    @bind()

  suggestSpot: (e)=>
    input = e.target.value
    $(e.target).autocomplete
      source: (req, res)->
        $.ajax
          url: "/users/suggest_spot"
          type: "GET"
          data:
            input: input
          dataType: "json"
          success: (data) =>
            places = []
            for prediction in data.predictions
              place = prediction.structured_formatting.main_text
              description = prediction.structured_formatting.secondary_text
              places.push {label: "#{place} -#{description}", value: "#{place}"}
            res places
      autoFocus: true
      delay: 200
    return

  bind: =>
    @$root.on "keyup", ".spot-name", @suggestSpot

$(document).on "turbolinks:load", ->
  new autoCompleteSpot $(".spot-container")
