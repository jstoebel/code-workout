class CreateQuestions < ActiveRecord::Migration
  def up
    create_table :questions do |t|
        t.string :title
        t.string :body
        t.string :tags
        t.integer :user_id
        t.integer :exercise_id
<<<<<<< HEAD
        
=======
	t.integer :upvote
	t.integer :downvote
>>>>>>> 50192a7d44428cb0a637c760b33c1a9486e33aa0
        t.timestamps
    end
    add_foreign_key :questions, :users
    add_foreign_key :questions, :exercises

   end

  def down
    drop_table :questions
  end
end
