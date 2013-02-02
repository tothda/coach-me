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
      groupKey = App.Utils.startOfWeek(x.get('startedAt')).getTime()
      groups.get(groupKey).push(x)
      
    groups.forEach (k,v) =>
      result.push(v)
    
    result
  .property('completed')
