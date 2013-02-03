App.TrainingsShowController = Em.ObjectController.extend
  editing: false
  
  edit: ->
    @set('editing', true)