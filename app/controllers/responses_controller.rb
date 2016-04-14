class ResponsesController < ApplicationController

  authorize_resource
  def index
  end

  def show
	@response = Response.find(params[:id])
  authorize! :read, @response
  end

  def new
  end

  def create
    @response = Response.new(safe_assign)
    @response.user_id = current_user.id
    authorize! :create, @response
    @question = Question.find(@response.question_id)
    @responses = Response.all.where(question_id: @question.id) 

    if @response.save
      flash[:success] = "Response saved!"
      redirect_to question_path(@response.question.id)
    else
      flash[:error] = "Error creating your response."
      render 'questions/show'
    end
  end

  def edit
    @response = Response.find(params[:id])
    authorize! :edit, @response
  end

  def update
    @response = Response.find(params[:id])
    authorize! :update, @response
    @response.assign_attributes(safe_assign)
    if @response.save
      flash[:success] = "Response edit saved!"
      redirect_to question_path(@response.question.id)
    else
      flash[:error] = "Error editing your response."
      render :template => 'responses/edit', :id => @response
    end
  end

  def delete
    @response = Response.find(params[:response_id])
    authorize! :destroy, @response
  end

  def destroy
    @response = Response.find(params[:id])
    authorize! :destroy, @response
    @response.destroy
    redirect_to question_path(@response.question_id)
    flash[:success] = "You have successfully deleted the response"    
  end

  private
  def safe_assign
    params.require(:response).permit( :text, :question_id )
  end

end
