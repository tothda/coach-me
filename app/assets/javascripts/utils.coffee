App.Utils =
  startOfWeek: (date) ->
    start = date.clone()
    monday = if start.is().monday()
      start
    else
      start.previous().monday()
      
    start.clearTime()
    
  # https://gist.github.com/1180489
  pad: (a,b) -> ([1e15] + a).slice(-b)