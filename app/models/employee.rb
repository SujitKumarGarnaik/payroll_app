class Employee < ApplicationRecord
  belongs_to :user, optional: true

  validates :name, :email, :age, :phone_number, :designation, :address, :salary, :date_of_birth, :date_of_joining, presence: true
  validates :email, uniqueness: true
  validates :gender, inclusion: { in: ["Male", "Female", "Other"], message: "%{value} is not a valid gender" }

  has_many :payslips, dependent: :destroy
  validates :employee_id, uniqueness: true
end