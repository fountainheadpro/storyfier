class Storyfier.Routers.StoryRouter extends Backbone.Router

  initialize: (story) ->
    @story=new Storyfier.Models.Story(story)
    @questions_info=@story.questions_info
    @questions=new Storyfier.Collections.QuestionsCollection()
    @current_question = @questions_info.first().get('media')


  routes:
    ".*"       : "show"
    ":question" : "show"

  locations:
    "first_story" : window.home

  show: (question) ->
    unless question?
      @navigate "#{@current_question}", {trigger: true}
      return
    unless @questions.get(question)?
      new_question=new Storyfier.Models.Question(@questions_info.get(question).attributes)
      @questions.add(new_question)
      new_question.fetch(
        noCSRF: true
        success: (data)=>
          view=@navigate_story(question)
        error: (model,err)=>
          console.log(err)
      )
    else
      @navigate_story(question)
    @current_question=question


  navigate_story:(question) ->
    console.log("Moving to the question: #{question}")
    #window.log("question", {action: 'enter', label: question})
    model=@questions.get(question)
    @show_question(model) unless @qview?
    @qview.change_question(model)
    @qview

  current_portion: ()->
    @qview.current_portion


  show_question: (model)->
    #view = new Storyfier.Views.StoryView(model: @story)
    #$("#story").html(view.render().el)
    view = new Storyfier.Views.QuestionView(model: model)
    $("#story").append(view.render().el)
    @qview=view

  load_next_step: (answer) ->
    if @next_step()
      @navigate @next_step(), {trigger: true}
    else
      @story.questions_info.fetch(
        success: (data)=>
          if @next_step()?
            next_step=@next_step()
            @navigate next_step, {trigger: true}
          else
            window.location=@locations[@story.get("name")]
      )

  next_step: ()->
    @questions_info.get(@current_question).get('next_step')
