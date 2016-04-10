class ReviewController < ApplicationController
	def index
		@flags = Question.where.not(:flags => nil)
	end

	def show
		@flags = Question.find(params[:id])
	end

	def dismiss
	end

	def approve
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
