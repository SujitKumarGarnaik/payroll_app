class User < ApplicationRecord

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_one :employee, dependent: :destroy
  
  after_initialize :set_default_role, if: :new_record?

  validates :role, presence: true, inclusion: { in: ['admin', 'employee'], message: "%{value} is not a valid role" }

  def set_default_role
    self.role ||= 'employee'
  end

  def admin?
    role == 'admin'
  end

  def employee?
    role == 'employee'
  end

  def check_admin
    unless current_user.admin?
      redirect_to root_path, alert: 'You are not authorized to access this page.'
    end
  end

end
