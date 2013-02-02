App.Utils =
  startOfWeek: (date) ->
    start = date.clone()
    monday = if start.is().monday()
      start
    else
      start.previous().monday()
      
    start.clearTime()