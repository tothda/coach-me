App.TrainingsIndexRoute = Em.Route.extend
  model: ->
    App.Training.find()