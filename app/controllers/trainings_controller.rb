class TrainingsController < ApplicationController
  skip_authorization_check
  before_filter :initialize_athlete
  before_filter :authorize_read, :only => [:index, :show]
  before_filter :authorize_manage, :except => [:index, :show]
  
  include TrainingsHelper
  # GET /trainings
  # GET /trainings.json
  def index
    authorize! :read_trainings, @athlete
    @user = @athlete

    trainings = Training.where("started_at > ? and user_id = ?", Date.today - 1.year, @user.id)
    @training_groups = group_trainings_for_index_page(trainings, Date.today)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trainings }
    end
  end

  # GET /trainings/1
  # GET /trainings/1.json
  def show
    @training = Training.find(params[:id])
    
    authorize! :read_trainings, @training.user
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @training }
    end
  end

  # GET /trainings/new
  # GET /trainings/new.json
  def new
    @training = Training.new
    @training.user = @athlete
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @training }
    end
  end

  # GET /trainings/1/edit
  def edit
    authorize! :manage_trainings, @athlete
    @training = Training.find(params[:id])
  end

  # POST /trainings
  # POST /trainings.json
  def create
    @training = Training.new(params[:training])
    @training.user = @athlete

    @training.title = 'Untitled'
    @training.started_at = Date.today
    
    respond_to do |format|
      if @training.save
        format.html { redirect_to "#{training_path(@training)}/#/edit", notice: 'Training was successfully created.' }
        format.json { render json: @training, status: :created, location: @training }
      else
        format.html { render action: "new" }
        format.json { render json: @training.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trainings/1
  # PUT /trainings/1.json
  def update
    @training = Training.find(params[:id])
    respond_to do |format|
      if @training.update_attributes(params[:training])
        format.html { redirect_to @training, notice: 'Training was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @training.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trainings/1
  # DELETE /trainings/1.json
  def destroy
    @training = Training.find(params[:id])
    @training.destroy

    respond_to do |format|
      format.html { redirect_to trainings_url }
      format.json { head :no_content }
    end
  end

  private

  def initialize_athlete
    @athlete = if params[:user_id]
                User.find(params[:user_id])
              else
                current_user
              end
  end

  def authorize_manage
    authorize! :manage_trainings, @athlete
  end

  def authorize_read
    authorize! :read_trainings, @athlete
  end
end
