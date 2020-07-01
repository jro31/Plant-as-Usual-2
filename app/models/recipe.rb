class Recipe < ApplicationRecord
  NUMBER_OF_RECIPES_OF_THE_DAY = 1.freeze
  NUMBER_OF_FEATURED_RECIPES = 10.freeze

  belongs_to :user
  has_many :ingredients, dependent: :destroy

  mount_uploader :photo, PhotoUploader

  # validate :validate_not_currently_featured
  # validate :validate_one_recipe_of_the_day
  # validate :validate_number_of_featured_recipes

  after_save :update_state_updated_at

  scope :approved, -> { where(state: [:approved, :approved_for_feature, :approved_for_recipe_of_the_day]) }
  scope :approved_for_feature, -> { where(state: [:approved_for_feature, :approved_for_recipe_of_the_day]) }
  scope :approved_for_recipe_of_the_day, -> { where(state: :approved_for_recipe_of_the_day) }
  scope :currently_featured, -> { where(state: [:currently_featured, :recipe_of_the_day_as_currently_featured]) }
  scope :current_recipes_of_the_day, -> { where(state: :current_recipe_of_the_day) }
  scope :currently_highlighted, -> { where(state: [:currently_featured, :recipe_of_the_day_as_currently_featured, :current_recipe_of_the_day]) }
  scope :awaiting_approval, -> { where(state: :awaiting_approval) }
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

    after_transition [:currently_featured, :recipe_of_the_day_as_currently_featured] => any do |_|
      Recipe.set_next_featured_recipe
    end

    after_transition :current_recipe_of_the_day => any do |_|
      Recipe.set_next_recipe_of_the_day
    end
  end

  def self.update_highlighted_recipes
    puts "🐳🐳🐳🐳🐳🐳🐳🐳🐳🐳🐳🐳🐳🐳🐳🐳"
    update_recipe_of_the_day
    update_featured_recipes
  end

  def self.update_recipe_of_the_day
    self.current_recipes_of_the_day.each do |recipe|
      recipe.revert_from_highlighted if recipe.last_recipe_of_the_day_at >= 23.hours.ago
    end
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
      recipe.revert_from_highlighted if recipe.last_featured_at >= 23.hours.ago
    end
  end

  def self.set_next_featured_recipe
    return if self.currently_featured.count >= ::NUMBER_OF_FEATURED_RECIPES

    new_featured_recipe = self.next_recipe_to_feature
    return unless new_featured_recipe

    new_featured_recipe.feature
    new_featured_recipe.touch(:last_featured_at)
  end

  def self.next_recipe_to_feature
    never_featured_recipes = self.approved_for_feature
                                 .where(last_featured_at: nil)
                                 .order(created_at: :asc)
    return never_featured_recipes.first if never_featured_recipes.any?

    self.approved_for_feature.order(last_featured_at: :asc).first
  end

  def update_state_updated_at
    return unless saved_change_to_state?

    touch(:state_updated_at)
  end

  def currently_featured?
    # COMPLETE THIS
  end

  def validate_not_currently_featured # ADD THIS VALIDATION TO INGREDIENTS AS WELL
    return unless currently_featured?

    errors.add(:process, "Recipe cannot be updated while it is featured on the homepage")
  end

  def validate_number_of_recipes_of_the_day
    # errors.add(:state, "There can only be one recipe of the day")
  end

  def validate_number_of_featured_recipes
    # COMPLETE THIS
  end
end
