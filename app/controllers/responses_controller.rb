class ResponsesController < ApplicationController
  def index
  end

  def show
    @response = Response.find(params[:id])
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def delete
    @response = Response.find(params[:response_id])
  end

  def destroy
    @response = Response.find(params[:id])
    @response.destroy
    redirect_to questions_path(@response.question_id)
    flash[:success] = "You have successfully deleted the response"    
  end
end
