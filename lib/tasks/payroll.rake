namespace :payroll do
  desc "Generate payslips for all employees"
  task generate_payslips: :environment do
    Employee.find_each do |employee|
      PayrollJob.perform_later(employee.id)  
    end
  end
end
