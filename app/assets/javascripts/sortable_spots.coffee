class SortableSpots
  constructor: (@$root)->
    @bind()

  openSortableModal: =>
    $modal = $(".sortable-modal .modal")
    $spot_form = @$root.find(".spot-form").not(".deleted")
    positions = _.map $spot_form.find(".spot-position"), (position)=> position.value
    names = _.map $spot_form.find(".spot-name"), (name)=> name.value
    $fragment = $(document.createDocumentFragment())
    iteration = _.range positions.length
    _.forEach iteration, (i)=>
      $item = $("<div class=sortable-item data-position=#{positions[i]}></div>")
      $position = $("<div class=sortable-position>#{positions[i]}</div>")
      $name = $("<div class=sortable-name>#{names[i]}</div>")
      $item.append($position).append($name)
      $fragment.append $item
    $modal_body = $modal.find(".modal-body")
    $modal_body.html $fragment
    $modal.modal()
    $modal_body.sortable
      axis: "y"
      item: ".sortable-item"
    return

  submitSortable: =>
    $modal = $(".sortable-modal .modal")
    orders = _.map $modal.find(".sortable-item"), (item)=> $(item).data("position") - 1
    $positions = @$root.find(".spot-form").not(".deleted").find(".spot-position")
    iteration = _.range orders.length
    _.forEach iteration, (i)=> $positions[orders[i]].value = i + 1
    $(".submit-sortable").click()
    return

  bind: =>
    $(".sortable-spot-btn").on "click", @openSortableModal
    $(".confirm-sortable-btn").on "click", @submitSortable

$(document).on "turbolinks:load", ->
  new SortableSpots $(".spot-container")
