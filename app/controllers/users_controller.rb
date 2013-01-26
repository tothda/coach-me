class UsersController < ApplicationController
  load_and_authorize_resource
  
  def index
    authorize! :manage, :users
    @users = User.order("id desc").all
  end

  def show
    
  end
end
