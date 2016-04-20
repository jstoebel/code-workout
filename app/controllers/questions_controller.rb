class QuestionsController < ApplicationController

  authorize_resource
  def index
     #pre:
	#Question.all: Sellects all items in the table Question
     #post: All items of the Question table are shown
	#question#index is rendered
    if params[:exercise_id]
      @questions = Question.where(exercise_id: params[:exercise_id]) 
    else
      @questions = Question.all
    end  
  end

  def search
    #nothing for now
  end

  def show
    #pre:
      #exercise_id: The exercise this question should be associated with
      #params[:id] (optional): The exercise this resqonses should be associated with
    #post: The sellected item of the Question table is shown along with any optional items sellected from the Response table
      #question#show is rendered
    
    @question = Question.find(params[:id])
    authorize! :read, @question
    @responses = Response.all.where(question_id: params[:id])
    @response = Response.new
    @title = ''
    count = 0
    @question.title.split('').each do |i|    
      @title << i
      if i != " "
        count += 1
      end
      if count > 15
        @title << '...'
        break
      end
    end
  end

  def new
    #pre:
      #exercise_id (optional): the exercise this question should be associated
      #with
    #post: a new question object is instantiated but not saved
      #question#new is rendered

    @question = Question.new({
      :exercise_id => params[:exercise_id]
      })
    @new = true
  end

  def create
    #pre:
      #params: the parameters to be used to create this question
    #post: 
      #a new question object is saved -> redirect to index
      #OR new question is not saved -> render new
    @question = Question.new(safe_assign)
    @question.user_id = current_user.id
    authorize! :create, @question

    if @question.save
      flash[:success] = "Question saved!"
      redirect_to questions_path
    else
      flash[:error] = "Error creating your question."
      render 'new'
    end

  end

  def edit
    #pre:
      #id: the id of the question to edit
    #post:
      #edit view is rendered
    @question = Question.find(params[:id])
    @title = ""
    count = 0
    @question.title.split('').each do |i|
      @title << i
      if i != " "
        count += 1
      end
      if count > 15
        @title << '...'
        break
      end
    end
    @edit = true
    authorize! :edit, @question
  end

  def update
    #pre:
      #params: question attributes to be assigned
    #post
      #the question object is saved -> redirect to index
      #OR new question is not saved -> render edit
    @question = Question.find(params[:id])
    authorize! :update, @question

    @question.assign_attributes(safe_assign)

    if @question.save
      flash[:success] = "Question saved!"
      redirect_to question_path
    else
      flash[:error] = "Error updating question."
      render 'edit'      
    end
  end

  def delete
    @question = Question.find(params[:question_id])
    authorize! :destroy, @question
  end

  def destroy
    @question = Question.find(params[:id])
    authorize! :destroy, @question

    @question.destroy
    redirect_to questions_path
    flash[:success] = "You have successfully deleted the question"    
  end

  def up_vote
    @question = Question.find(params[:id])

    if @question.up_votes.create(user_id: current_user.id)
      redirect_to question_path
    else 
      flash[:notice] = "You have already up-voted this question!"
    end

   #respond_to do |format|
   # @question.increment!(:up_vote)
    #format.html { redirect_to @question, notice: 'Cool'}
   # format.json{ render :show, status: :created, location: @question } 
    #format.js
   #redirect_to question_path
   # end
  end

  def down_vote
    @question=Question.find(params[:id])

    if @question.down_votes.create(user_id: current_user.id)
      redirect_to question_path
    else 
      flash[:notice] = "You have already down-voted this question!"
    end
  end

  private
  def safe_assign

    params.require(:question).permit(:title, :body, :tags, :exercise_id, :up_vote, :down_vote, :flags)

  end

end
