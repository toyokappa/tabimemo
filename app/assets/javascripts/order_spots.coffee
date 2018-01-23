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
    $modal_body.sortable { item: ".sortable-item" }
    $modal.modal()

  bind: =>
    @$root.on "click", ".sortable-spot-btn", @openSortableModal

$(document).on "turbolinks:load", ->
  new SortableSpots $(".spot-container")
