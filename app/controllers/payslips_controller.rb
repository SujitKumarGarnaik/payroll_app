class PayslipsController < ApplicationController
    before_action :authenticate_user!
  
    def index
      if current_user.admin?
        @payslips = Payslip.includes(:employee).all
      else
        @payslips = current_user.employee.payslips
      end
    end
  
    def download
      payslip = Payslip.find(params[:id])
    
      if current_user.admin? || payslip.employee.user == current_user
        pdf_generator = PayslipPdf.new(payslip.employee, [payslip]) 
        pdf_path = pdf_generator.generate_pdf  
    
        send_file pdf_path, type: 'application/pdf', disposition: 'inline'
      else
        redirect_to payslips_path, alert: "You are not authorized to view this payslip."
      end
    end
    
  end
  