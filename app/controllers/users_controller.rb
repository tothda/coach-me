class UsersController < ApplicationController
  load_and_authorize_resource
  respond_to :html, :json
  
  def index
    authorize! :manage, :users
    @users = User.order("id desc").all
  end

  def show
    @user = User.find(params[:id])
    authorize! :read, @user
    
    respond_with(@user)
  end
end
