class Storyfier.Models.Question extends Backbone.Model
  paramRoot: 'question'

  idAttribute: "media"

  defaults:
    title: null
    sub_title: null
    enable_animation: false

  initialize: ()->
    @on("change:options", @init_options)
    @on("change:continue", @add_option)

  init_options:()->
    if @has('options')
      @options=new Storyfier.Collections.OptionsCollection(@get('options'), validate: false)
      @unset('options')

  add_option:()->
    if @has('continue') && @get('continue')
      @options=new Storyfier.Collections.OptionsCollection()
      @options.add(new Storyfier.Models.Option(title: 'continue'))

  url: ()->
    return @get('media_url')



class Storyfier.Collections.QuestionsCollection extends Backbone.Collection
  model: Storyfier.Models.Question
  url: '/assets/questions'
