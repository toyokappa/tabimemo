class autoCompleteSpot
  constructor: (@$root)->
    @bind()

  suggestSpot: (e)=>
    input = e.target.value
    $.ajax
      url: "/users/suggest_spot"
      type: "GET"
      data:
        input: input
      dataType: "json"
      success: (res) =>
        for item in res.predictions
          console.log item.structured_formatting.main_text
          console.log item.structured_formatting.secondary_text
    return

  bind: =>
    @$root.on "change", ".spot-name", @suggestSpot

$(document).on "turbolinks:load", ->
  new autoCompleteSpot $(".spot-container")
