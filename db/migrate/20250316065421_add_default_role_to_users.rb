class AddDefaultRoleToUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_default :users, :role, 'employee'
  end
end
