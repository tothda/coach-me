App.Training = DS.Model.extend
  title: DS.attr('string')
  startedAt: DS.attr('date')
  
  startedAtMonthAndDay: Em.computed ->
    @get('startedAt').toString('MMM dd')
  .property('startedAt')
  
  startedAtNameOfDay: Em.computed ->
    @get('startedAt').toString('dddd')
  .property('startedAt')