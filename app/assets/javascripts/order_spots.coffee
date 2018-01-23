class OrderSpots
  constructor: (@$root)->
    @bind()

  openOrderModal: =>
    $modal = $(".order-modal .modal")
    $spot_form = @$root.find(".spot-form").not(".deleted")
    positions = _.map $spot_form.find(".spot-position"), (position)=> position.value
    names = _.map $spot_form.find(".spot-name"), (name)=> name.value
    $fragment = $(document.createDocumentFragment())
    iteration = _.range positions.length
    _.forEach iteration, (i)=>
      $item = $("<div class=order-item data-order=#{positions[i]}></div>")
      $position = $("<div class=order-position>#{positions[i]}</div>")
      $name = $("<div class=order-name>#{names[i]}</div>")
      $item.append($position).append($name)
      $fragment.append $item
    $modal.find(".modal-body").html $fragment
    $modal.modal()

  bind: =>
    @$root.on "click", ".order-spot-btn", @openOrderModal

$(document).on "turbolinks:load", ->
  new OrderSpots $(".spot-container")
