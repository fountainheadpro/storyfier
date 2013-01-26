class Storyfier.Models.Story extends Backbone.Model
  paramRoot: 'conversation'

  initialize: ()->
    @questions_info=new Storyfier.Collections.QuestionsCollection(@get('questions'))
    @questions_info.url="/conversation/#{@get('name')}"
    @unset('questions')




