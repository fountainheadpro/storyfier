class Storyfier.Models.UserValue extends Backbone.Model
  urlRoot: '/user_values'

class Storyfier.Collections.UserValuesCollection extends Backbone.Collection
  model: Storyfier.Models.UserValue
  url: '/user_values'
