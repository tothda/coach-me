module TrainingsHelper

  def group_trainings_for_index_page(trainings, today)
    groups = []
    tc = trainings.count
    st = trainings.sort_by {|t| t.started_at}.reverse # sorted trainings
    oldest = st.last.started_at
    newest = st.first.started_at

    # weeks represented by their end
    week = newest.end_of_week
    ptr = 0 # pointing the next trainings to be grouped
    
    while oldest < week do
      prev_week = week - 1.week
      w = OpenStruct.new
      w.week = week.dup
      w.trainings = []
      groups << w

      while ptr < tc && prev_week < st[ptr].started_at && st[ptr].started_at <= week do
        w.trainings << st[ptr]
        ptr += 1
      end

      w.future = week.beginning_of_week > today
      w.past = week.end_of_week < today
      w.current = week.beginning_of_week <= today && week.end_of_week >= today
      
      week = week - 1.week
    end

    groups
  end
end
