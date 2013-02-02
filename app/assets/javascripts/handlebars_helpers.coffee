Ember.Handlebars.registerBoundHelper 'formatDate', (value, options) ->
  if Em.isEmpty(value)
    return ''
  
  format = options.hash.format
  
  value.toString(format)
    
Ember.Handlebars.registerBoundHelper 'formatNumber', (value, options) ->
  value = 0 if Em.isEmpty(value)
  format = options.hash.format || ".00"
  App.Utils.numberFormat(format, value)
    