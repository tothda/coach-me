App.ExerciseController = Em.ObjectController.extend
  
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
  
  _timeToHourMinSec: (time) ->
    h = Math.floor(time / 3600)
    m = Math.floor((time - h * 3600) / 60)
    s = time - h * 3600 - m * 60
    return [h,m,s]
    
  deleteExercise: ->
    @get('content').deleteRecord()
    
  editing: Em.computed.alias('target.target.editing')
  