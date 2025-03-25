class AdminsController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    if current_user.admin?
      @employees = Employee.all  
    else
      redirect_to root_path, alert: "You are not authorized to view this page."
    end
  end

  def new
    @employee = Employee.new
  end

  def send_payslip
    employee = Employee.find(params[:id])  
    pdf_path = generate_payslip_pdf(employee) 

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

  def generate_payslip_pdf(employee)
    pdf = Prawn::Document.new
    pdf.text "Payslip for #{employee.name}", size: 20, style: :bold
    pdf.text "Salary: $#{employee.salary}", size: 15
    pdf_path = Rails.root.join("tmp", "payslip_#{employee.id}.pdf")
    pdf.render_file(pdf_path) 
    pdf_path.to_s
  end
  
end
