class UsersController < ApplicationController
  load_and_authorize_resource
  
  def index
    authorize! :manage, :users
    @users = User.all
  end

  def show
    
  end
end
