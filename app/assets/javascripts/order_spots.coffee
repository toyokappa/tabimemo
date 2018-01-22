class OrderSpots
  constructor: (@$root)->
    @bind()

  openOrderModal: =>
    $modal = $(".order-modal .modal")
    $modal.modal()

  bind: =>
    @$root.on "click", ".order-spot-btn", @openOrderModal

$(document).on "turbolinks:load", ->
  new OrderSpots $(".spot-container")
