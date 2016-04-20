# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :up_vote do
    value 1
    question_id 1
    user_id 1
  end
end
