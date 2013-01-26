Storyfier.Views ||= {}

class Storyfier.Views.QuestionView extends Backbone.View
  template: JST["apps/conversation/templates/question_show"]

  className: 'question_container'

  events:
    'option_selected .option' : 'play_followup'
    'feedback_saved .feedback_container' : 'feedback_saved'
    'email_saved .signup_container' : 'email_saved'
    'finished_question' : 'finished_question'
    'finished_option' : 'finished_option'
    'change_question' : "change_question"

  render: ->
    $(@el).html(@template(@model.toJSON()))
    @

  change_question: (model)->
    @model=model
    @cleanup()
    @current_portion='question'
    if @model.has('qimage')
      img=$("<img/>")
      $(img).attr('src',@model.get('qimage'))
      $(img).addClass('question_moving_image')
      $(@el).append(img)
      @$('.question_moving_image').addClass('final')
    if @model.options?
      @options_view = new Storyfier.Views.OptionIndexView({model: @model})
      @$('.options_alignment').html(@options_view.render().el)
    if @model.fields?
      @fiels_view = new Storyfier.Views.FieldIndexView({model:  @model.fields})
      @$el.append(@fiels_view.render().el)

  cleanup: ->
    @$('.question_moving_image').remove()
    @options_view?.remove()

  play_followup: (e)->
    @$('.options_container').fadeOut(750)
    @current_portion='option'
    if e.option?.has('video')
      Storyfier.router.video_view.play_option(e.option)
      return
    if e.option?.has('flash_animation')
      @swf_view.change_screen(e.option)
      return
    @finished_option(e)

  finished_option : (e)->
    Storyfier.router.load_next_step(e.option?.get('param_value'))

  finished_question: (e)->
    @current_portion='option'
    if @model.options?
      @$('.options_container').show()
    if @model.fields?
      @$('.fields_container').show()
      @$('.field_value:first').focus()
    if @model.has('feedback')
      @feedback_view=new Storyfier.Views.FeedbackView(model: @model.get('feedback'))
      @$el.append(@feedback_view.render().el)
    if @model.has('email')
      @email_view=new Storyfier.Views.EmailView(model: @model.get('email'))
      @$el.append(@email_view.render().el)


