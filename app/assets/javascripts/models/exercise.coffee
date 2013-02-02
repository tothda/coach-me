App.Exercise = DS.Model.extend
  name: DS.attr('string')
  distance: DS.attr('number')
  training: DS.belongsTo('App.Training')