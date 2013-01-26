Storyfier.Views ||= {}

class Storyfier.Views.ShowOptionView extends Backbone.View
  template: JST["apps/storyfier/templates/option_show"]

  attributes:
    class: "option"

  events:
    "click" : "save_selection"

  render: ->
    $(@el).html(@template({title: @model.get('title')}))
    return this

  save_selection: (e) ->
    e.preventDefault()
    @model.save_value_and_next()