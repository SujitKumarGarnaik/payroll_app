class AdminsController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @employees = Employee.all  
  end

  def new
    @employee = Employee.new
  end

  def send_payslip
    employee = Employee.find(params[:id])
    payslips = employee.payslips 
  
    pdf_generator = PayslipPdf.new(employee, payslips)
    pdf_path = pdf_generator.generate_pdf
  
    PayslipMailer.send_payslip(employee, pdf_path).deliver_now
  
    flash[:notice] = "Payslip sent to #{employee.email}"
    redirect_to admin_dashboard_path
  end
  


  private

  def authenticate_admin
    unless current_user && current_user.admin?
      redirect_to root_path, alert: 'You are not authorized to view this page.'
    end
  end

  
end
