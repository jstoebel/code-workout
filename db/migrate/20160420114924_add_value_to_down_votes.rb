class AddValueToDownVotes < ActiveRecord::Migration
  def change
    add_column :down_votes, :value, :integer
  end
end
