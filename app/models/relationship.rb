class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  # Rails 5以降は書かなくても良い
  # validates :follower_id, presence: true
  # validates :followed_id, presence: true
end
