# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    title "Question title"
    body "This is the body of the question \n its just a sample."
    tags "loops; conditionals"
    after(:create) do |q|
      create_pair(:response, {question_id: q.id, user_id: q.user_id})
    end
  end
end