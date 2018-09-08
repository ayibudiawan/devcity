class User < ApplicationRecord
  has_many :posts

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :trackable

  mount_uploader :profile_picture, AvatarUploader

  validates_presence_of :email, :password

  def self.friend_list(email)
    response = {"status" => false, "message" => ""}
    if email.blank?
      response["message"] = "Email can't be blank"
    else
      user = User.find_by_email(email)
      if user.blank?
        response["message"] = "User with email #{email} not found"
      else
        user_ids = Activity.where("requestor_id = ? and target_id != ? and is_friend = ?", user.id, user.id, true).pluck(:target_id)
        users = user_ids.present? ? User.where("id IN (?)", user_ids).pluck(:email).uniq : []
        response["status"] = true
        response["friends"] = users
        response["count"] = users.count
      end
    end

    return response
  end

  def friends
    Activity.where(:requestor_id => self.id, :is_friend => true)
  end

  def is_act?(user, act)
    Activity.find_by_requestor_id_and_target_id(self.id, user.id).send(act)
  end
end
