class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :recipes, dependent: :destroy
  has_many :user_favourite_recipes, dependent: :destroy
  has_many :favourites, through: :user_favourite_recipes, class_name: 'Recipe', source: :recipe

  validates :username, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 16 }, format: { without: /\s/, message: 'cannot contain spaces' }
  validates :twitter_handle, :instagram_handle, :website_url, format: { without: /\s/, message: 'cannot contain spaces' }

  before_validation :strip_whitespace, :sanitize_social_media_handles
  after_create :send_sign_up_slack_message

  private

  def strip_whitespace
    ['username', 'email', 'twitter_handle', 'instagram_handle', 'website_url'].each do |column|
      self.send(column).strip! if self.send(column)
    end
  end

  def sanitize_social_media_handles
    self.twitter_handle = self.twitter_handle[1..-1] if self.twitter_handle && self.twitter_handle[0] == '@'
    self.instagram_handle = self.instagram_handle[1..-1] if self.instagram_handle && self.instagram_handle[0] == '@'
  end

  def send_sign_up_slack_message
    SendSlackMessageJob.perform_later("A new user has signed-up, username: #{username}, email: #{email}", nature: 'celebrate')
  end
end
