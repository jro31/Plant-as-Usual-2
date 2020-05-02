class Recipe < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  has_many :ingredients, dependent: :destroy
end
