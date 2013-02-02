App.Training = DS.Model.extend
  title: DS.attr('string')
  startedAt: DS.attr('date')
  
  startedAtDay: Em.computed ->
    @get('startedAt').toString('yyyy.MM.dd')
  .property('startedAt')