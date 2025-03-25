class PayslipMailer < ApplicationMailer
  default from: 'kumar@gmail.com'

  def send_payslip(employee, pdf_path)
    @employee = employee
    @month_year = Date.today.strftime('%B %Y')

    if File.exist?(pdf_path)
      attachments["Payslip_#{employee.name}_#{@month_year}.pdf"] = File.read(pdf_path)
    else
      Rails.logger.error "Payslip PDF not found at: #{pdf_path}"
      return
    end

    mail(
      to: @employee.email,
      subject: "Your Payslip for #{@month_year}"
    ) do |format|
      format.text { render plain: "Dear #{@employee.name},\n\nPlease find attached your payslip for #{@month_year}.\n\nBest Regards,\nYour Company" }
      format.html { render 'payslip_mailer/send_payslip' }
    end
  end
end
