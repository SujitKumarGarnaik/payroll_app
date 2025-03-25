class AddCascadeDeleteToEmployees < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :employees, :users
    add_foreign_key :employees, :users, on_delete: :cascade
  end
end
