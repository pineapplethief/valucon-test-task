class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.belongs_to :user, index: true, foreign_key: true

      t.string :name, null: false
      t.text   :description
      t.string :state

      t.timestamps null: false
    end
  end
end
