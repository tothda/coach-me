App.ApplicationRoute = Ember.Route.extend
  redirect: ->
    currentUser = App.get('currentUser')
    if Em.isEmpty(currentUser)
      console.log 'Not logged in.', currentUser
      @transitionTo('login')

  events:
    logout: ->
      App.set('currentUser', null)
      @transitionTo 'login'