class Recipe < ApplicationRecord
  belongs_to :user
  has_many :ingredients, dependent: :destroy

  mount_uploader :photo, PhotoUploader

  state_machine initial: :incomplete do # SPEC THIS
    event :complete do
      transition incomplete: :awaiting_approval
    end

    event :revised do
      transition [:awaiting_approval, :approved, :approved_for_feature, :approved_for_recipe_of_the_day, :declined] => :incomplete
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

    event :decline do
      transition awaiting_approval: :declined
    end

    event :hide do
      transition all => :hidden
    end
  end
end
