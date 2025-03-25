class GeneratePayslipsJob < ApplicationJob
    queue_as :default
  
    def perform
      Employee.find_each do |employee|
        payslip = employee.payslips.create(month: Date.today.end_of_month)
        SendPayslipJob.perform_later(payslip)
      end
    end
  end
  