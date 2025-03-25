class AddGenderToEmployees < ActiveRecord::Migration[8.0]
  def change
    add_column :employees, :gender, :string
  end
end
