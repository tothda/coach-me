CoachMe.TrainingsRoute = Em.Route.extend
  model: ->
    CoachMe.Training.find()