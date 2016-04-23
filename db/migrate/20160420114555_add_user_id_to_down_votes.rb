class AddUserIdToDownVotes < ActiveRecord::Migration
  def change
    add_column :down_votes, :user_id, :integer
  end
end
