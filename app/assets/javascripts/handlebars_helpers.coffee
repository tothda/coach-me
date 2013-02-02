Ember.Handlebars.registerBoundHelper 'formatDate', (value, options) ->
  if Em.isEmpty(value)
    return ''
  
  format = options.hash.format
  
  value.toString(format)
    
  
