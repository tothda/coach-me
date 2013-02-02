App.WeekGroup = Em.Object.extend
  classNameBindings: ['current']
  trainings: []
  beginning: null
  
  totalDistance: Em.computed ->
    @get('trainings').mapProperty('totalDistance').reduce(((acc, item) -> acc + item), 0)
  .property('trainings.@each.totalDistance')
  
  end: Em.computed ->
    @get('beginning').addDays(6).at({hour:23,minute:59,second:59})
  .property('beginning')