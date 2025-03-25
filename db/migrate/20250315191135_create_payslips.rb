class CreatePayslips < ActiveRecord::Migration[8.0]
    def change
      create_table :payslips do |t|
        t.references :employee, null: false, foreign_key: true
        t.string :month
        t.decimal :salary
        t.datetime :generated_at
  
        t.timestamps
      end
    end
  end
  