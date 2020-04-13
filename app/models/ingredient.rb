class Ingredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :unit, optional: true

  UNITS = %w(
    gram millilitre pinch splash teaspoon tablespoon cup dash litre
    kilogram piece inch centimetre can pack clove whole large medium
    small leaf pound ounce pint fluid ounce quart gallon sprig
  ).freeze
end
