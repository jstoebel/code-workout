# Read about factories at https://github.com/thoughtbot/factory_girl

    FactoryGirl.define do
      factory :response do
        text "response text"
        user
        question
      end
    end
