this.App = Ember.Application.create
  ready: ->
    updateClockFn = -> App.set('time', new Date())
    setInterval(updateClockFn , 60000)
    updateClockFn();
    
    userId = Em.$('body').attr('data-user-id')
    unless Em.isEmpty(userId)
      App.set('currentUser', App.User.find(userId))
      
App.LOG_TRANSITIONS = true

Ember.TextSupport.reopen({
  attributeBindings: ["data-behaviour", 'style']
})