class Recipe < ApplicationRecord
  belongs_to :user

  has_many :ingredients, dependent: :destroy

  mount_uploader :photo, PhotoUploader
end
