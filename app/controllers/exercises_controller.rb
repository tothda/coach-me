class ExercisesController < ApplicationController
  # POST /exercises
  # POST /exercises.json
  def create
    @training = Training.find(params[:training_id])
    @exercise = @training.exercises.build(params[:exercise])
    authorize! :create, @exercise
    @exercise.save
    redirect_to training_path(@training)
  end

  # PUT /exercises/1
  # PUT /exercises/1.json
  def update
    @exercise = Exercise.find(params[:id])
    authorize! :update, @exercise
    if @exercise.update_attributes(params[:exercise])
      render text: "", status: 200
    else
      render text: "", status: 500
    end
  end

  # DELETE /exercises/1
  # DELETE /exercises/1.json
  def destroy
    @training = Training.find(params[:training_id])
    @exercise = Exercise.find(params[:id])
    authorize! :destroy, @exercise
    @exercise.destroy

    respond_to do |format|
      format.html { redirect_to training_url(@training) }
      format.json { head :no_content }
    end
  end
end
