class AddFlagsToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :flags, :string
  end
end
