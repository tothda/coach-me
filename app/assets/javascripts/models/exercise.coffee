App.Exercise = DS.Model.extend
  name: DS.attr('string')
  distance: DS.attr('number')
  training: DS.belongsTo('App.Training')
  time: DS.attr('number')
  position: DS.attr('number')
  
  formattedTime: Em.computed ->
    time = @get('time')
    [h,m,s] = @_timeToHourMinSec(time)
    
    if h == 0 && m == 0
      "%@s".fmt(s)
    else if h == 0
      "%@m %@s".fmt(m,s)
    else
      "%@h %@m %@s".fmt(h,m,s)
  .property('time')
  
  timeForEdit: Em.computed (key, value) ->
    if value
      1
    pad = App.Utils.pad
    time = @get('time')
    [h,m,s] = @_timeToHourMinSec(time)
    if h == 0
      "%@:%@".fmt(pad(m,2),pad(s,2))
    else
      "%@:%@:%@".fmt(h,pad(m,2),pad(s,2))
  .property('time')
  
  _timeToHourMinSec: (time) ->
    h = Math.floor(time / 3600)
    m = Math.floor((time - h * 3600) / 60)
    s = time - h * 3600 - m * 60
    return [h,m,s]