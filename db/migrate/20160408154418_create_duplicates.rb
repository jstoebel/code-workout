class CreateDuplicates < ActiveRecord::Migration
	def up
	    create_table :duplicates do |t|
	        t.text :duplicate_msg
	        t.boolean :approved
	        t.integer :a_user_id
	        t.integer :r_user_id
	        t.integer :current_question_id
	        t.integer :duplicated_question_id
	        t.timestamps
    end

    	add_foreign_key :duplicates, :users, column: :a_user_id
    	add_foreign_key :duplicates, :users, column: :r_user_id 
    	add_foreign_key :duplicates, :questions, column: :current_question_id
    	add_foreign_key :duplicates, :questions, column: :duplicated_question_id
  	end

	def down
		drop_table :duplicates
	end
end
