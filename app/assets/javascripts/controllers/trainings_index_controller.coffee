App.TrainingsIndexController = Em.ArrayController.extend
  sortProperties: ['startedAt']
  sortAscending: false

  completed: Em.computed ->
    model = @get('arrangedContent')
    now = new Date()
    model.filter (x)=>
      Date.compare(now, x.get('startedAt')) == 1
  .property('arrangedContent.@each.startedAt')
  
  completedByWeek: Em.computed ->
    completed = @get('completed')
    result = []
    groups = Em.MapWithDefault.create(defaultValue: (()-> []))
    
    completed.map (x) =>
      groupKey = @startOfWeek(x.get('startedAt'))
      groups.get(groupKey).push(x)
      
    groups.forEach (k,v) =>
      result.push(v)
    
    result
  .property('completed')
  
  startOfWeek: (date) ->
    start = date.clone()
    monday = if start.is().monday()
      start
    else
      start.previous().monday()
      
    start.clearTime().getTime()