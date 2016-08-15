class AddFileToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :file, :string
  end
end
