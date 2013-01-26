Storyfier.Views ||= {}

class Storyfier.Views.OptionIndexView extends Backbone.View

  id: "options"

  attributes:
    class: "options_container"

  initialize: () ->
    _.bindAll(this, 'addOne', 'addAll', 'render')
    @options=@model.options
    @options.bind('reset', @addAll)

  addAll: () ->
    i=0
    @options.each (option) =>
      @addOne(option)

  addOne: (option) ->
    view= new Storyfier.Views.ShowOptionView(model: option)
    @$el.append(view.render().el)

  render: ->
    @addAll()
    return this