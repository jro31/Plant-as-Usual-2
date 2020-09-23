class Recipe < ApplicationRecord
  NUMBER_OF_RECIPES_OF_THE_DAY = 1.freeze
  NUMBER_OF_FEATURED_RECIPES = 12.freeze

  belongs_to :user
  has_many :ingredients, dependent: :destroy

  mount_uploader :photo, PhotoUploader

  validate :validate_number_of_featured_recipes
  validate :validate_number_of_recipes_of_the_day

  after_save :set_next_featured_recipe, if: :saved_change_to_state?
  after_save :set_next_recipe_of_the_day, if: :saved_change_to_state?
  after_save :send_awaiting_approval_slack_message, if: :saved_change_to_state?
  after_save :update_state_updated_at, if: :saved_change_to_state?

  scope :approved, -> { where(state: [:approved, :approved_for_feature, :approved_for_recipe_of_the_day]) }
  scope :approved_for_feature, -> { where(state: [:approved_for_feature, :approved_for_recipe_of_the_day]) }
  scope :approved_for_recipe_of_the_day, -> { where(state: :approved_for_recipe_of_the_day) }
  scope :currently_featured, -> { where(state: [:currently_featured, :recipe_of_the_day_as_currently_featured]) }
  scope :current_recipes_of_the_day, -> { where(state: :current_recipe_of_the_day) }
  scope :currently_highlighted, -> { where(state: [:currently_featured, :recipe_of_the_day_as_currently_featured, :current_recipe_of_the_day]) }
  scope :awaiting_approval, -> { where(state: :awaiting_approval) }
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
      transition awaiting_approval: :approved
    end

    event :approve_for_feature do
      transition awaiting_approval: :approved_for_feature
    end

    event :approve_for_recipe_of_the_day do
      transition awaiting_approval: :approved_for_recipe_of_the_day
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

    event :decline do
      transition awaiting_approval: :declined
    end

    event :hide do
      transition all => :hidden
    end
  end

  def self.update_highlighted_recipes
    update_recipes_of_the_day
    update_featured_recipes
  end

  def self.update_recipes_of_the_day
    self.current_recipes_of_the_day.each do |recipe|
      recipe.revert_from_highlighted if recipe.last_recipe_of_the_day_at <= 23.hours.ago
    end

    (NUMBER_OF_RECIPES_OF_THE_DAY - Recipe.current_recipes_of_the_day.count).times { self.set_next_recipe_of_the_day }
  end

  def self.set_next_recipe_of_the_day
    return if self.current_recipes_of_the_day.count >= NUMBER_OF_RECIPES_OF_THE_DAY

    new_recipe_of_the_day = self.next_recipe_of_the_day
    return unless new_recipe_of_the_day

    new_recipe_of_the_day.set_as_recipe_of_the_day
    new_recipe_of_the_day.touch(:last_recipe_of_the_day_at)
  end

  def self.next_recipe_of_the_day
    never_recipe_of_the_day_recipes = self.approved_for_recipe_of_the_day
                                          .where(last_recipe_of_the_day_at: nil)
                                          .order(created_at: :asc)
    return never_recipe_of_the_day_recipes.first if never_recipe_of_the_day_recipes.any?

    self.approved_for_recipe_of_the_day.order(last_recipe_of_the_day_at: :asc).first
  end

  def self.update_featured_recipes
    self.currently_featured.each do |recipe|
      recipe.revert_from_highlighted if recipe.last_featured_at <= 23.hours.ago
    end

    (NUMBER_OF_FEATURED_RECIPES - Recipe.currently_featured.count).times { self.set_next_featured_recipe }
  end

  def self.set_next_featured_recipe
    return if self.currently_featured.count >= NUMBER_OF_FEATURED_RECIPES

    new_featured_recipe = self.next_recipe_to_feature
    return unless new_featured_recipe

    new_featured_recipe.feature
    new_featured_recipe.touch(:last_featured_at)
  end

  def self.next_recipe_to_feature
    return if self.approved_for_feature.count.zero?

    never_featured_recipes = self.approved_for_feature
                                 .where(last_featured_at: nil)
                                 .order(created_at: :asc)
    return never_featured_recipes.first if never_featured_recipes.any?

    self.approved_for_feature.order(last_featured_at: :asc).first
  end

  def awaiting_approval?
    state == 'awaiting_approval'
  end

  def has_photo?
    photo.present?
  end

  private

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

    errors.add(:state, "There can only be one recipe of the day")
  end
end
