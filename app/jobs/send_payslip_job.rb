class SendPayslipJob < ApplicationJob
  queue_as :default

  def perform(employee, payslip, pdf_path)
    PayslipMailer.send_payslip(employee, payslip, pdf_path).deliver_now
  end
end
