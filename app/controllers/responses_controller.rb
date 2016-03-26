class ResponsesController < ApplicationController
  def index
  end

  def show
	@response = Response.find(params[:id])
>>>>>>> origin
  end

  def new
  end

  def create
    @response = Response.new(safe_assign)
    @response.user_id = current_user.id

    if @response.save
      flash[:success] = "Response saved!"
      redirect_to question_path(@response.question.id)
    else
      flash[:error] = "Error creating your response."
      # render :template => "questions/show"
    end
  end

  def edit
    @response = Response.find(params[:id])
  end

  def update
    @response = Response.find(params[:id])
    @response.assign_attributes(safe_assign)

    if @response.save
      flash[:success] = "Response edit saved!"
      redirect_to question_path(@response.question.id)
    else
      flash[:error] = "Error editing your response."
      # render :template => "questions/show"
    end
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

  private
  def safe_assign
    params.require(:response).permit( :text, :question_id )
  end

end
