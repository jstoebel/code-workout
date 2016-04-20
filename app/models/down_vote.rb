class DownVote < ActiveRecord::Base
	belongs_to :user
	belongs_to :question
	#validates_uniqueness_of :question_id, scope: :user_id
	validates_uniqueness_of :user_id, :scope => [:question_id]
end
