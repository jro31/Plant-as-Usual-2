class Recipe < ApplicationRecord
  belongs_to :user
  has_many :ingredients, dependent: :destroy

  mount_uploader :photo, PhotoUploader

  validate :validate_not_currently_featured
  validate :validate_one_recipe_of_the_day

  after_save :update_state_updated_at

  scope :approved, -> { where(state: [:approved, :approved_for_feature, :approved_for_recipe_of_the_day]) }
  scope :approved_for_feature, -> { where(state: [:approved_for_feature, :approved_for_recipe_of_the_day]) }
  scope :approved_for_recipe_of_the_day, -> { where(state: :approved_for_recipe_of_the_day) }
  scope :awaiting_approval, -> { where(state: :awaiting_approval) }
  scope :not_hidden, -> { where.not(state: :hidden) }
  scope :current_recipe_of_the_day, -> { where(state: :current_recipe_of_the_day).first }

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

    event :revert_from_featured do
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

  def self.update_featured_recipes
    recipe_of_the_day.touch(:last_recipe_of_the_day_at)
    featured_recipes.each{ |recipe| recipe.touch(:last_featured_at) }
  end

  # Don't allow recipe of the day or featured recipes to be updated - use currently_featured? below
  # Use @user_can_edit in recipes controller to achieve this on front end
  # Use pundit to achieve it on the back-end
  # Display banner to users explaining this, e.g: ‘As this recipe is currently featured on our homepage, it cannot be updated. Please check back tomorrow to update.’
  def self.recipe_of_the_day
    never_featured_recipes = self.approved_for_recipe_of_the_day
                                 .where(last_recipe_of_the_day_at: nil)
                                 .where('state_updated_at <= ?', recipe_of_the_day_last_updated)
                                 .order(created_at: :asc)
    return never_featured_recipes.first if never_featured_recipes.any?

    self.approved_for_recipe_of_the_day.order(last_recipe_of_the_day_at: :asc).first
  end

  def self.featured_recipes
    # COMPLETE THIS
  end

  def self.recipe_of_the_day_last_updated
    self.order(last_recipe_of_the_day_at: :desc).last.last_recipe_of_the_day
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

  def validate_one_recipe_of_the_day
    # return unless Recipe.current_recipe_of_the_day.count > 1

    # errors.add(:state, "There can only be one recipe of the day")
  end
end
