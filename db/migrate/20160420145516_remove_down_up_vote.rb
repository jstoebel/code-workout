class RemoveDownUpVote < ActiveRecord::Migration
	def up
		change_table :questions do |t|
			t.remove :up_vote
			t.remove :down_vote
		end
	end
	def down
		change_table :questions do |t|
			t.integer :up_vote
			t.integer :down_vote
		end
	end
end
