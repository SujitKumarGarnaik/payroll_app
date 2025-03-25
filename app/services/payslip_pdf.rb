require 'prawn'

class PayslipPdf
  def initialize(employee, payslips)
    @employee = employee
    @payslips = payslips
    @pdf = Prawn::Document.new
    generate_content
  end

  def generate_pdf
    pdf_path = Rails.root.join("tmp", "Payslip_#{@employee.id}_#{Date.today.strftime('%B_%Y')}.pdf")
    @pdf.render_file(pdf_path)
    pdf_path
  end

  private

  def generate_content
    header
    employee_details
    salary_details
  end

  def header
    @pdf.text "Dayspring Technology", size: 26, style: :bold, align: :center
    @pdf.move_down 5
    @pdf.text "Payslip for the month of #{Date.today.strftime('%B,%Y')}", size: 16, style: :bold, align: :center
    @pdf.move_down 5
    financial_year_start = (Date.today.month >= 4) ? Date.today.year : Date.today.year - 1
    financial_year_end = financial_year_start + 1
    @pdf.text "Financial Year #{financial_year_start}-#{financial_year_end}", size: 14, style: :bold, align: :center
    @pdf.move_down 20
  end

  def employee_details
    @pdf.text "Employee Details", size: 14, style: :bold
    @pdf.move_down 5
    @pdf.text "Name: #{@employee.name}"
    @pdf.text "Employee Id: #{@employee.employee_id}"
    @pdf.text "Designation: #{@employee.designation}"
    @pdf.text "Gender: #{@employee.gender}"
    @pdf.text "Date of Joining: #{@employee.date_of_joining.strftime('%d-%m-%Y')}"
    @pdf.move_down 50
  end

  def salary_details
    basic_salary = @employee.salary.to_f  
    allowances = basic_salary * 0.20  
    medical_allowance = basic_salary * 0.02
    net_salary = basic_salary + allowances + medical_allowance

    @pdf.text "Salary Details", size: 14, style: :bold
    @pdf.move_down 5
    @pdf.text "Basic Salary: #{'%.2f' % basic_salary}", size: 12
    @pdf.text "Allowances: #{'%.2f' % allowances}", size: 12
    @pdf.text "Medical Allowance: #{'%.2f' % medical_allowance}", size: 12
    @pdf.move_down 5
    @pdf.text "Net Salary: #{'%.2f' % net_salary}", size: 12

    @pdf.move_down 50
    @pdf.text "Generated on: #{Time.current.strftime('%d-%m-%Y')}", size: 10, align: :right
    @pdf.text "This is a computer-generated document and does not need a signature", size: 10, align: :right

    @pdf.move_down 200
    @pdf.text "Dayspring Technology", size: 16, style: :bold, align: :center
    @pdf.move_down 50
    @pdf.text "#357, 4th Main, 6th Cross, BSK 3rd Stage, 29/1, 5th Main Rd, Kaveri Nagar, Banagirinagara, Banashankari 3rd Stage, Banashankari, Bengaluru, Karnataka - 560085"
  end
end
