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
        send_file PayslipPdfGenerator.generate(payslip), type: 'application/pdf', disposition: 'inline'
      else
        redirect_to payslips_path, alert: "You are not authorized to view this payslip."
      end
    end
  end
  