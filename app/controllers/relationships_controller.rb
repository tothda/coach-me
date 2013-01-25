class RelationshipsController < ApplicationController
  load_and_authorize_resource
  
  def create
    @relationship = Relationship.new(params[:relationship])

    if @relationship.save
      redirect_to users_path
    else
      throw "Error creating relationship"
    end
  end

  def destroy
    @relationship = Relationship.find(params[:id])
    @relationship.destroy
    redirect_to users_path
  end
end
