class ReviewController < ApplicationController
	def index
		@flag = Question.where.not(:flags => nil)
	end

	def show
		@flag = Question.find(params[:id])
	end

	def dismiss
		@flag = Question.find(params[:id])
		@flag.flags = nil 
		@dup = Duplicates.where(:current_question_id => @flag.id)
		@dup.destroy
	end

	def approve
		@flag = Question.find(params[:id])
		@flag.flags = true 
		@dup = Duplicates.where(:current_question_id => @flag.id)
		@dup.approved = true
		@dup.current_question_id = @flag.id
	end

	def new
	end

	def create
	end

	def edit
	end

	def update
	end

	def destroy
	end

	def delete
	end
end
