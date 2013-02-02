App.WeekGroup = Em.Object.extend
  trainings: []
  totalDistance: Em.computed ->
    @get('trainings').mapProperty('totalDistance').reduce(((acc, item) -> acc + item), 0)
  .property('trainings.@each.totalDistance')