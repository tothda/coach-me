App.Training = DS.Model.extend
  title: DS.attr('string')
  startedAt: DS.attr('date')
  feeling: DS.attr('string')
  
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