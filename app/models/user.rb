class User < ApplicationRecord
  EDITABLE_COLUMNS = {
    username: 'username',
    email: 'email',
    password: 'password',
    twitter_handle: 'twitter_handle',
    instagram_handle: 'instagram_handle',
    website_url: 'website_url'
  }.freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :recipes, dependent: :destroy
  has_many :user_favourite_recipes, dependent: :destroy
  has_many :favourites, through: :user_favourite_recipes, class_name: 'Recipe', source: :recipe

  validates :username, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 16 }, format: { without: /\s/, message: 'cannot contain spaces' }
  validates :twitter_handle, :instagram_handle, :website_url, format: { without: /\s/, message: 'cannot contain spaces' }

  validate :validate_email

  before_validation :strip_whitespace, :replace_empty_strings_with_nil, :sanitize_social_media_handles
  after_create :send_sign_up_slack_message

  def self.editable_column_labels
    {
      self::EDITABLE_COLUMNS[:username] => 'username',
      self::EDITABLE_COLUMNS[:email] => 'email',
      self::EDITABLE_COLUMNS[:password] => 'password',
      self::EDITABLE_COLUMNS[:twitter_handle] => 'Twitter handle',
      self::EDITABLE_COLUMNS[:instagram_handle] => 'Instagram username',
      self::EDITABLE_COLUMNS[:website_url] => 'personal website'
    }
  end

  def self.editable_column_hints
    {
      self::EDITABLE_COLUMNS[:username] => 'This will be visible to other users.',
      self::EDITABLE_COLUMNS[:email] => nil,
      self::EDITABLE_COLUMNS[:twitter_handle] => 'Optional. This will be visible to other users.',
      self::EDITABLE_COLUMNS[:instagram_handle] => 'Optional. This will be visible to other users.',
      self::EDITABLE_COLUMNS[:website_url] => 'Optional. This will be visible to other users.'
    }
  end

  def self.editable_column_placeholders
    {
      self::EDITABLE_COLUMNS[:username] => nil,
      self::EDITABLE_COLUMNS[:email] => nil,
      self::EDITABLE_COLUMNS[:twitter_handle] => '@plantasusual',
      self::EDITABLE_COLUMNS[:instagram_handle] => 'plantasusual',
      self::EDITABLE_COLUMNS[:website_url] => 'https://www.plantasusual.com/'
    }
  end

  private

  def validate_email
    return unless will_save_change_to_email? && email

    errors.add(:email, "must contain exactly one '@'") unless User.number_of_at_symbols(email) == 1
    errors.add(:email, "must contain a full stop") unless User.number_of_full_stops(email) >= 1
  end

  def strip_whitespace
    ['username', 'email', 'twitter_handle', 'instagram_handle', 'website_url'].each do |column|
      self.send(column).strip! if self.send(column)
    end
  end

  def replace_empty_strings_with_nil
    self.twitter_handle = nil unless self.twitter_handle.present?
    self.instagram_handle = nil unless self.instagram_handle.present?
    self.website_url = nil unless self.website_url.present?
  end

  def sanitize_social_media_handles
    self.twitter_handle = self.twitter_handle[1..-1] if self.twitter_handle && self.twitter_handle[0] == '@'
    self.instagram_handle = self.instagram_handle[1..-1] if self.instagram_handle && self.instagram_handle[0] == '@'
  end

  def send_sign_up_slack_message
    SendSlackMessageJob.perform_later("A new user has signed-up, username: #{username}, email: #{email}", nature: 'celebrate')
  end

  def self.no_or_number(amount)
    ApplicationController.helpers.no_or_number(amount)
  end

  def self.number_of_at_symbols(string)
    ApplicationController.helpers.number_of_at_symbols(string)
  end

  def self.number_of_full_stops(string)
    ApplicationController.helpers.number_of_full_stops(string)
  end
end
