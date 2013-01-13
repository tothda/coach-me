module TrainingsHelper

  def group_trainings_for_index_page(trainings)
    groups = []
    tc = trainings.count
    st = trainings.sort_by {|t| t.started_at} # sorted trainings
    oldest = st.first.started_at
    newest = st.last.started_at

    # weeks represented by their first day
    week = oldest.beginning_of_week
    ptr = 0 # pointing the next trainings to be grouped
    
    while week < newest do
      next_week = week + 1.week
      w = OpenStruct.new
      w.week = week.dup
      w.trainings = []
      groups << w

      while ptr < tc && week <= st[ptr].started_at && st[ptr].started_at < next_week do
        w.trainings << st[ptr]
        ptr += 1
      end
      
      week = week + 1.week
    end
    
    groups.reverse
  end
end
