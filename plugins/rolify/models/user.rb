class User < ActiveRecord::Base
  has_and_belongs_to_many :roles

  def has_role? role
    user_roles.each {|r| return true if r == role.to_s}
    false
  end

  def user_roles
    self.roles.map {|r| r.role }
  end
end
