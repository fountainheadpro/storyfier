class Storyfier.Models.Option extends Backbone.Model
  paramRoot: 'options'

  save_value_and_next: ->
    #@save_value(()=>Storyfier.router.load_next_step(@get('param_value')))
    Storyfier.router.load_next_step()

  save_value: (success) ->
    question=Storyfier.router.current_question
    uv=new Storyfier.Models.UserValue()
    uv.save({value: @get('param_value'), question: question},
      success: ()=>
        #window.log("question", {action: 'answer', label: question , value: @get('param_value'), answer: question+"_"+@get('param_value') })
        success?.call(this)
    )


class Storyfier.Collections.OptionsCollection extends Backbone.Collection
  model: Storyfier.Models.Option
