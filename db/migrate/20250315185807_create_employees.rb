class CreateEmployees < ActiveRecord::Migration[8.0]
  def change
    create_table :employees do |t|
      t.string :name
      t.integer :age
      t.text :address
      t.string :email
      t.string :salary
      t.string :decimal
      t.date :date_of_birth
      t.date :date_of_joining
      t.string :designation
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
