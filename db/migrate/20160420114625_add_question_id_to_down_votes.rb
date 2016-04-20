class AddQuestionIdToDownVotes < ActiveRecord::Migration
  def change
    add_column :down_votes, :question_id, :integer
  end
end
