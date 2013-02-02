App.Training = DS.Model.extend
  title: DS.attr('string')
  startedAt: DS.attr('date')
  feeling: DS.attr('string')
  exercises: DS.hasMany('App.Exercise')
  
  feelingValue: Em.computed ->
    value = @get('feeling')
    return 0 if Em.isEmpty(value)
    switch value
      when "injured" then 1
      when "sluggish" then 2
      when "soso" then 3
      when "good" then 4
      when "awesome" then 5
  .property('feeling')
  
  totalDistance: Em.computed ->
    @get('exercises').mapProperty('distance').reduce(((acc, item) -> acc + item), 0).toFixed(2)
  .property('exercises.@each.distance')