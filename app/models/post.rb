class Post < ApplicationRecord
  belongs_to :user
  validates_presence_of :description

  delegate :username, to: :user, prefix: false
end
