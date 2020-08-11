class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :recipes, dependent: :destroy
  has_many :user_favourite_recipes, dependent: :destroy
  has_many :favourites, through: :user_favourite_recipes, class_name: 'Recipe', source: :recipe

  validates :username, uniqueness: true, length: { minimum: 3 }
end
