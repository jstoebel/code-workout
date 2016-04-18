class AddDownVoteToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :down_vote, :integer
  end
end
