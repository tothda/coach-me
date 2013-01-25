module ApplicationHelper
  def myself?(user)
    user == current_user
  end
end
