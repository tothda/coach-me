App.TrainingsShowController = Em.ObjectController.extend
  editing: false
    
  edit: ->
    @set('editing', true)
    transaction = @get('store').transaction()
    transaction.add(@get('model'))
    
  cancel: ->
    @set('editing', false)
    @get('model.transaction').rollback()
    
  save: ->
    @set('editing', false)
    @get('model.transaction').commit()
    
  startedAtFmt: Em.computed (key, value) ->
    if value
      @get('model').set('startedAt', Date.parse(value))
      
    @get('model.startedAt').format('%Y.%m.%d')
  .property('model.startedAt')