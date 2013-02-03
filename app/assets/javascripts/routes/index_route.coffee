App.IndexRoute = Em.Route.extend
  redirect: ->
    @transitionTo('trainings.index')