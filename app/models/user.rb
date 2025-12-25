class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable
  
  enum role: [:user, :member, :admin]
  after_initialize :set_default_role, if: :new_record?
  
  has_many :sector_permissions, dependent: :destroy
  has_many :permitted_sectors, through: :sector_permissions, source: :sector

  def set_default_role
    self.role ||= :user
  end
  
end
