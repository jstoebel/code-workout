class Question < ActiveRecord::Base
    has_many :responses, :dependent => :delete_all
    belongs_to :user
    belongs_to :exercise
end
