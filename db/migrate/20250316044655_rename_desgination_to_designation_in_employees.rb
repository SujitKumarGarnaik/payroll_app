class RenameDesginationToDesignationInEmployees < ActiveRecord::Migration[8.0]
  def change
    rename_column :employees, :desgination, :designation
  end
end
