class GeneratePayslipsJob < ApplicationJob
  queue_as :default

  def perform
    Employee.find_each do |employee|
      payslip = employee.payslips.create(month: Date.today.end_of_month)
      pdf_path = PayslipPdfGenerator.generate(payslip)
      
      SendPayslipJob.perform_later(employee, payslip, pdf_path)
    end
  end
end
