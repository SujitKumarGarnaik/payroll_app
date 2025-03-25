class Payslip < ApplicationRecord
  belongs_to :employee
  has_one_attached :pdf
  validates :month, :salary, :generated_at, presence: true
end
