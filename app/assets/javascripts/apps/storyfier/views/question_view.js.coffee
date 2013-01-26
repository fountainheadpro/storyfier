Storyfier.Views ||= {}

class Storyfier.Views.QuestionView extends Backbone.View
  template: JST["apps/storyfier/templates/question_show"]

  className: 'question_container'

  #events:
    #'option_selected .option' : 'play_followup'
    #'feedback_saved .feedback_container' : 'feedback_saved'
    #'email_saved .signup_container' : 'email_saved'
    #'finished_question' : 'finished_question'
    #'finished_option' : 'finished_option'
    #'change_question' : "change_question"

  render: ->
    $(@el).html(@template(@model.toJSON()))
    @

  change_question: (model)->
    @model=model
    @cleanup()
    if @model.has('image')
      image_path="/assets/#{@model.get('image')}.jpg"
      $('.question_image_container').css('background-image', "url('#{image_path}')")
    if (@model.has('tap') && @model.get('tap'))
      $('.question_image_container').on('click',
        ()->
          Storyfier.router.load_next_step()
      )
    else
      $('.question_image_container').off('click')
    if @model.options?
      @options_view = new Storyfier.Views.OptionIndexView({model: @model})
      @$el.append(@options_view.render().el)


  cleanup: ->
    @options_view?.remove()

