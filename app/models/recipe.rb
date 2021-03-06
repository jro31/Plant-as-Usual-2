class Recipe < ApplicationRecord
  NUMBER_OF_RECIPES_OF_THE_DAY = 1.freeze
  NUMBER_OF_FEATURED_RECIPES = 12.freeze

  belongs_to :user
  has_many :ingredients, dependent: :destroy
  has_many :user_favourite_recipes, dependent: :destroy

  attr_accessor :mark_as_complete

  mount_uploader :photo, PhotoUploader

  validate :validate_number_of_featured_recipes
  validate :validate_number_of_recipes_of_the_day
  validate :validate_decline_reason

  accepts_nested_attributes_for :ingredients, allow_destroy: true

  before_validation :remove_declined_reason, if: :will_save_change_to_state?
  after_save :state_changed_methods, if: :saved_change_to_state?

  scope :approved, -> { where(state: [:approved, :approved_for_feature, :approved_for_recipe_of_the_day]) }
  scope :approved_for_feature, -> { where(state: [:approved_for_feature, :approved_for_recipe_of_the_day]) }
  scope :approved_for_recipe_of_the_day, -> { where(state: :approved_for_recipe_of_the_day) }
  scope :currently_featured, -> { where(state: [:currently_featured, :recipe_of_the_day_as_currently_featured]).order(last_featured_at: :asc) }
  scope :current_recipes_of_the_day, -> { where(state: :current_recipe_of_the_day) }
  scope :currently_highlighted, -> { where(state: [:currently_featured, :recipe_of_the_day_as_currently_featured, :current_recipe_of_the_day]) }
  scope :awaiting_approval, -> { where(state: :awaiting_approval) }
  scope :incomplete, -> { where(state: :incomplete) }
  scope :available_to_show, -> { where.not(state: [:incomplete, :declined, :hidden]) }
  scope :not_hidden, -> { where.not(state: :hidden) }

  state_machine initial: :incomplete do
    event :complete do
      transition incomplete: :awaiting_approval
    end

    event :revised do
      transition [:awaiting_approval, :approved, :approved_for_feature, :approved_for_recipe_of_the_day, :currently_featured, :recipe_of_the_day_as_currently_featured, :current_recipe_of_the_day, :declined] => :incomplete
    end

    event :approve do
      transition [:incomplete, :awaiting_approval] => :approved
    end

    event :approve_for_feature do
      transition [:incomplete, :awaiting_approval] => :approved_for_feature
    end

    event :approve_for_recipe_of_the_day do
      transition [:incomplete, :awaiting_approval] => :approved_for_recipe_of_the_day
    end

    event :feature do
      transition approved_for_feature: :currently_featured
      transition approved_for_recipe_of_the_day: :recipe_of_the_day_as_currently_featured
    end

    event :set_as_recipe_of_the_day do
      transition approved_for_recipe_of_the_day: :current_recipe_of_the_day
    end

    event :revert_from_highlighted do
      transition currently_featured: :approved_for_feature
      transition [:recipe_of_the_day_as_currently_featured, :current_recipe_of_the_day] => :approved_for_recipe_of_the_day
    end

    event :decline do # REQUIRES declined_reason TO BE ASSIGNED BEFORE CALLING
      transition [:incomplete, :awaiting_approval] => :declined
    end

    event :hide do
      transition all => :hidden
    end
  end

  class << self
    def update_highlighted_recipes
      update_recipes_of_the_day
      update_featured_recipes
    end

    def update_recipes_of_the_day
      self.current_recipes_of_the_day.each do |recipe|
        recipe.revert_from_highlighted if recipe.last_recipe_of_the_day_at <= 23.hours.ago
      end

      (NUMBER_OF_RECIPES_OF_THE_DAY - Recipe.current_recipes_of_the_day.count).times { self.set_next_recipe_of_the_day }
    end

    def set_next_recipe_of_the_day
      return if self.current_recipes_of_the_day.count >= NUMBER_OF_RECIPES_OF_THE_DAY

      new_recipe_of_the_day = self.next_recipe_of_the_day
      return unless new_recipe_of_the_day

      new_recipe_of_the_day.set_as_recipe_of_the_day
      new_recipe_of_the_day.touch(:last_recipe_of_the_day_at)
    end

    def next_recipe_of_the_day
      never_recipe_of_the_day_recipes = self.approved_for_recipe_of_the_day
                                            .where(last_recipe_of_the_day_at: nil)
                                            .order(created_at: :asc)
      return never_recipe_of_the_day_recipes.first if never_recipe_of_the_day_recipes.any?

      self.approved_for_recipe_of_the_day.order(last_recipe_of_the_day_at: :asc).first
    end

    def update_featured_recipes
      self.currently_featured.each do |recipe|
        recipe.revert_from_highlighted if recipe.last_featured_at <= 23.hours.ago
      end

      (NUMBER_OF_FEATURED_RECIPES - Recipe.currently_featured.count).times { self.set_next_featured_recipe }
    end

    def set_next_featured_recipe
      return if self.currently_featured.count >= NUMBER_OF_FEATURED_RECIPES

      new_featured_recipe = self.next_recipe_to_feature
      return unless new_featured_recipe

      new_featured_recipe.feature
      new_featured_recipe.touch(:last_featured_at)
    end

    def next_recipe_to_feature
      return if self.approved_for_feature.count.zero?

      never_featured_recipes = self.approved_for_feature
                                   .where(last_featured_at: nil)
                                   .order(created_at: :asc)
      return never_featured_recipes.first if never_featured_recipes.any?

      self.approved_for_feature.order(last_featured_at: :asc).first
    end

    def recipe_summary_message
      if awaiting_approval.count.zero? && incomplete.count.zero?
        "There are no awaiting approval or incomplete recipes"
      else
        "There #{is_or_are(awaiting_approval.count)} #{no_or_number(awaiting_approval.count)} #{'recipe'.pluralize(awaiting_approval.count)} awaiting approval, and #{no_or_number(incomplete.count)} incomplete #{'recipe'.pluralize(incomplete.count)} #{UrlMaker.new('admin').full_url}"
      end
    end

    def send_recipe_summary_message_to_slack
      SlackMessage.post_to_slack(self.recipe_summary_message, nature: 'inform')
    end
  end

  def awaiting_approval?
    state == 'awaiting_approval'
  end

  def available_to_show?
    !['incomplete', 'declined', 'hidden'].include?(state)
  end

  def has_photo?
    photo.present?
  end

  private

  def remove_declined_reason
    return if declined?

    self.declined_reason = nil
  end

  def state_changed_methods
    set_next_featured_recipe
    set_next_recipe_of_the_day
    send_awaiting_approval_slack_message
    update_state_updated_at
  end

  def set_next_featured_recipe
    return unless %w(currently_featured recipe_of_the_day_as_currently_featured).include?(state_before_last_save)

    self.class.set_next_featured_recipe
  end

  def set_next_recipe_of_the_day
    return unless state_before_last_save == 'current_recipe_of_the_day'

    self.class.set_next_recipe_of_the_day
  end

  def send_awaiting_approval_slack_message
    return unless awaiting_approval?

    SendSlackMessageJob.perform_later("'#{name}' by #{user.username} is awaiting approval #{UrlMaker.new('admin').full_url}", nature: 'surprise')
  end

  def update_state_updated_at # PERHAPS REMOVE THIS IF THERE'S NO NEED FOR state_updated_at
    return unless saved_change_to_state?

    touch(:state_updated_at)
  end

  def validate_number_of_featured_recipes
    return unless will_save_change_to_state? && (currently_featured? || recipe_of_the_day_as_currently_featured?)
    return unless Recipe.currently_featured.count >= NUMBER_OF_FEATURED_RECIPES

    errors.add(:state, "There can only be #{NUMBER_OF_FEATURED_RECIPES} featured recipes")
  end

  def validate_number_of_recipes_of_the_day
    return unless will_save_change_to_state? && current_recipe_of_the_day?
    return unless Recipe.current_recipes_of_the_day.count >= NUMBER_OF_RECIPES_OF_THE_DAY

    errors.add(:state, 'There can only be one recipe of the day')
  end

  def validate_decline_reason
    if declined_reason.present? && !declined?
      errors.add(:declined_reason, 'should not be present')
    elsif declined_reason.blank? && declined?
      errors.add(:declined_reason, 'should be present')
    end
  end

  def self.is_or_are(amount)
    ApplicationController.helpers.is_or_are(amount)
  end

  def self.no_or_number(amount)
    ApplicationController.helpers.no_or_number(amount)
  end
end
