App.Exercise = DS.Model.extend
  name: DS.attr('string')
  distance: DS.attr('number')
  training: DS.belongsTo('App.Training')
  time: DS.attr('number')
  
  formattedTime: Em.computed ->
    time = @get('time')
    h = Math.floor(time / 3600)
    m = Math.floor((time - h * 3600) / 60)
    s = time - h * 3600 - m * 60
    
    if h == 0 && m == 0
      "%@s".fmt(s)
    else if h == 0
      "%@m %@s".fmt(m,s)
    else
      "%@h %@m %@s".fmt(h,m,s)
  .property('time')