class SetMatchHeight
  constructor: (@$root)->
    @$root.find(".match-height").matchHeight()

$(document).on "turbolinks:load", ->
  new SetMatchHeight $(".set-match-height") if $(".set-match-height")[0]
