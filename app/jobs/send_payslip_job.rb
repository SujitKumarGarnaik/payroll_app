class SendPayslipJob < ApplicationJob
  queue_as :default

  def perform(payslip)
    PayslipMailer.send_payslip(payslip).deliver_now
  end
end
