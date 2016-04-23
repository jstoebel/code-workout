class Question < ActiveRecord::Base
    #ASSOCIATIONS
    
    has_many :responses, :dependent => :delete_all
    belongs_to :user
    belongs_to :exercise

    has_many :up_votes, dependent: :destroy
  	has_many :voted_users, through: :up_votes, source: :user

  	has_many :down_votes, dependent: :destroy
  	has_many :down_voted_users, through: :down_votes, source: :user


    #VALIDATIONS

    validates :title,
        presence: { message: "Question does not have a title."}

    validates :body,
        presence: { message: "Question does not have a body."}

end
