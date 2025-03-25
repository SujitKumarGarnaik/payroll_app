class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin, only: [:destroy]
  before_action :set_employee, only: [:edit, :update, :destroy, :generate_payslip, :download_payslip, :send_payslip]
  before_action :authorize_employee, only: [:edit, :update]


  def index
    if current_user.admin?
      @employees = Employee.all
    else
      redirect_to dashboard_path, alert: "Access denied!"
    end
  end

  
  def new
    @employee = Employee.new
  end

  def create
    @employee = current_user.build_employee(employee_params)  

    if @employee.save
      redirect_to employee_dashboard_path, notice: 'Employee details saved successfully.'
    else
      flash.now[:alert] = @employee.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
  end

  def update
    if @employee.update(employee_params)
      if current_user.admin?
        redirect_to admin_dashboard_path, notice: 'Employee details updated successfully!'
      else
        redirect_to employee_dashboard_path, notice: 'Employee details updated successfully!'
      end
    else
      flash.now[:alert] = @employee.errors.full_messages.to_sentence
      render :edit
    end
  end
  

  def dashboard
    @employee = current_user.employee
    if @employee.nil?
      redirect_to new_employee_path, notice: 'Please create your employee profile first to access the dashboard.'
    else
      @payslips = @employee.payslips.order(year: :desc, month: :desc)
    end
  end

  def destroy
    if @employee.destroy
      redirect_to employees_path, notice: 'Employee was successfully deleted.'
    else
      redirect_to employees_path, alert: 'Failed to delete employee.'
    end
  end

  def payslips
    @employee = Employee.find(params[:id])
    @payslips = @employee.payslips
  
    respond_to do |format|
      format.html
      format.pdf do
        pdf = PayslipPdfGenerator.generate(@payslips.last) 
        send_data pdf, filename: "Payslip_#{@payslips.last.month}.pdf", type: "application/pdf"
      end
    end
  end

  def send_payslip
    @employee = Employee.find(params[:id])
    @payslip = @employee.payslips.order(created_at: :desc).first 

    if @payslip&.pdf.attached?
      payslip_pdf_path = ActiveStorage::Blob.service.path_for(@payslip.pdf.key) 

      PayslipMailer.send_payslip(@employee, payslip_pdf_path).deliver_now
      flash[:notice] = "Payslip sent successfully to #{@employee.email}."
    else
      flash[:alert] = "Payslip not found!"
    end
    
    redirect_to admin_dashboard_path
  end
  

  def generate_payslip
    @employee = current_user.admin? ? Employee.find_by(id: params[:id]) : current_user.employee
  
    if @employee.nil?
      redirect_to employee_dashboard_path, alert: "Unauthorized access"
      return
    end
  
    @payslips = @employee.payslips
  
    respond_to do |format|
      format.html { redirect_to employee_dashboard_path, alert: "Invalid request format" }
      format.pdf do
        pdf_generator = PayslipPdf.new(@employee, @payslips)
        pdf_path = pdf_generator.generate_pdf
  
        send_file pdf_path, filename: "payslip_#{@employee.id}.pdf",
                            type: "application/pdf",
                            disposition: "inline"
      end
    end
  end  


  
  def download_payslip
    pdf = PayslipPdfGenerator.new(@employee).generate
    send_data pdf, filename: "payslip_#{@employee.id}.pdf", type: 'application/pdf', disposition: 'attachment'
  end


  private

  def set_employee
    @employee = Employee.find_by(id: params[:id])
    redirect_to employees_path, alert: 'Employee not found!' if @employee.nil?
  end

  def authorize_employee
    unless current_user.admin? || current_user.employee == @employee
      redirect_to employees_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def employee_params
    params.require(:employee).permit(:employee_id, :name, :gender, :email, :phone_number, :age, :address, :salary, :date_of_birth, :date_of_joining, :designation)
  end

  def check_admin
    unless current_user.admin?
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end
  
  
end
