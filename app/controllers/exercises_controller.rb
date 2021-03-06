class ExercisesController < ApplicationController
  respond_to :html, :json
  # POST /exercises
  # POST /exercises.json
  def create
    @training = Training.find(params[:exercise].delete(:training_id))
    @exercise = @training.exercises.build(params[:exercise])
    authorize! :manage_trainings, @training.user
    @exercise.save
    respond_with(@exercise)
  end

  # PUT /exercises/1
  # PUT /exercises/1.json
  def update
    params[:exercise].delete(:training_id)
    @exercise = Exercise.find(params[:id])
    authorize! :manage_trainings, @exercise.training.user
    if @exercise.update_attributes(params[:exercise])
      render text: "", status: 200
    else
      render text: "", status: 500
    end
  end

  # DELETE /exercises/1
  # DELETE /exercises/1.json
  def destroy
    @exercise = Exercise.find(params[:id])
    authorize! :manage_trainings, @exercise.training.user
    @exercise.destroy

    respond_to do |format|
      format.html { redirect_to training_url(@training) }
      format.json { head :no_content }
    end
  end
end
