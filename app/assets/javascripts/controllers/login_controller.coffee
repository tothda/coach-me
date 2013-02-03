App.LoginController = Em.Controller.extend
  email: null
  password: null
  
  login: ->
    console.log 'login'
    Em.$.ajax
      url: '/users/sign_in'
      type: 'POST'
      data:
        'user[email]': @get('email')
        'user[password]': @get('password')
      success: (resp) =>
        App.set('currentUser', App.User.find(resp.id))
        @send('loggedIn')
      error: (resp) =>
        console.log 'error', resp
    