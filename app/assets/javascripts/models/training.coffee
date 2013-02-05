_generateLabelProperty = (name) ->
  Em.computed ->
    options = App.Training[name.toUpperCase()]
    value = @get('name')
    options.findProperty(name, value).label
  .property(name)
  
App.Training = DS.Model.extend
  title: DS.attr('string')
  startedAt: DS.attr('date')
  feeling: DS.attr('string')
  weather: DS.attr('string')
  surface: DS.attr('string')
  temperature: DS.attr('string')
  notes: DS.attr('string')
  exercises: DS.hasMany('App.Exercise')
  
  liveExercises: Em.computed ->
    @get('exercises').filterProperty('isDeleted', false)
  .property('exercises.@each.isDeleted')
  
  feelingValue: Em.computed ->
    value = @get('feeling')
    option = App.Training.FEELING.findProperty('value', value)
    if option then option.star else 0
  .property('feeling')
  
  feelingLabel: _generateLabelProperty('feeling')
  temperatureLabel: _generateLabelProperty('temperature')
  weatherLabel: _generateLabelProperty('weather')
  surfaceLabel: _generateLabelProperty('surface')
  
  totalDistance: Em.computed ->
    @get('exercises').mapProperty('distance').reduce(((acc, item) -> acc + item), 0)
  .property('exercises.@each.distance')
  
# Feeling

App.Training.FEELING = [
  value: 'awesome'
  label: 'Awesome'
  star: 5
,
  value: 'good'
  label: 'Good'
  star: 4
,
  value: 'soso'
  label: 'So-so'
  star: 3
,
  value: 'sluggish'
  label: 'Sluggish'
  star: 2
,
  value: 'injured'
  label: 'Injured'
  star: 1
]

# Temperature

App.Training.TEMPERATURE = [
  value: 'hot'
  label: 'Hot'
,
  value: 'warm'
  label: 'Warm'
,
  value: 'mild'
  label: 'Mild'
,
  value: 'cold'
  label: 'Cold'
,
  value: 'freezing'
  label: 'Freezing'
]

# Weather

App.Training.WEATHER = [
  value: 'normal'
  label: 'Hot'
,
  value: 'rainy'
  label: 'Rainy'
,
  value: 'cloudy'
  label: 'Cloudt'
,
  value: 'sunny'
  label: 'Sunny'
,
  value: 'snowy'
  label: 'Snowy'
,
  value: 'windy'
  label: 'Windy'
]

# Surface

App.Training.SURFACE = [
  value: 'track'
  label: 'Running track'
,
  value: 'road'
  label: 'Road'
,
  value: 'offroad'
  label: 'Offroad'
,
  value: 'hills'
  label: 'Hills'
,
  value: 'mixed'
  label: 'Mixed'
,
  value: 'beach'
  label: 'Beach'
]