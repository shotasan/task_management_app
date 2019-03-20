class User < ApplicationRecord
  before_validation { email&.downcase! }
  before_destroy :deleting_ok?

  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 },
                  format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, presence: true, length: { minimum: 6 }

  has_secure_password
  
  has_many :tasks, dependent: :destroy

  private

  # adminがtrueのユーザー（管理者権限あり）がゼロにならないようにエラーを発生させる
  def deleting_ok?
    users = User.all
    admin_user_count = users.select{ |user| user.admin == true }.count
    if admin_user_count <= 1
      raise Exceptions::AdminUserDstroyError
    end
  end
end