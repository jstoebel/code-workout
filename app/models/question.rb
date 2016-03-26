class Question < ActiveRecord::Base
<<<<<<< HEAD
    has_many :responses, :dependent => :delete_all
=======

    #ASSOCIATIONS
    has_many :responses
>>>>>>> origin
    belongs_to :user
    belongs_to :exercise

    #VALIDATIONS

    validates :title,
        presence: { message: "Question does not have a title."}

    validates :body,
        presence: { message: "Question does not have a body."}

end
