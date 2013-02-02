App.Router.map ->
  @resource 'trainings', ->
    @route 'show', path: '/:training_id'
