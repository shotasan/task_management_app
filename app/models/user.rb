class User < ApplicationRecord
  before_validation { email&.downcase! }
  before_destroy :admin_user?

  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 },
                  format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, presence: true, length: { minimum: 6 }

  has_secure_password
  
  has_many :tasks, dependent: :destroy
  has_many :group_participants, dependent: :destroy

  private

  # 削除対象ユーザーが管理者権限を持っているかの判定
  def admin_user?
    deleting_ok? if self.admin == true
  end
  
  # adminがtrueのユーザー（管理者権限あり）がゼロにならないようにエラーを発生させる
  def deleting_ok?
    users = User.all
    admin_user_count = users.select{ |user| user.admin}.count
    if admin_user_count <= 1
      raise Exceptions::AdminUserDstroyError
    end
  end
end