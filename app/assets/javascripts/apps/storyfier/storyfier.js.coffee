#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

###

###

window.Storyfier =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  Mixins: {}
  video_init_time: new Date().getTime()
  init: (options) ->
    unless Storyfier.router?
      Storyfier.router = new Storyfier.Routers.StoryRouter(options)
      Backbone.history.start()
