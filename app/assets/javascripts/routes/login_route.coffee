App.LoginRoute = Em.Route.extend
  redirect: ->
    if App.get('currentUser')
      @transitionTo('trainings.index')

  events:
    loggedIn: ->
      @transitionTo('trainings.index')