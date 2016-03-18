# Read about factories at https://github.com/thoughtbot/factory_girl

    FactoryGirl.define do

      factory :question do
        title "a question"
        body "question body text"
        tags "for loops; conditionals"
        user
        exercise

      end
    end
