class CreateDownVotes < ActiveRecord::Migration
  def change
    create_table :down_votes do |t|

      t.timestamps
    end
  end
end
