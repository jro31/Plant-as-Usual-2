class Ingredient < ApplicationRecord
  belongs_to :recipe

  UNITS = %w(
    gram millilitre pinch splash teaspoon tablespoon cup dash litre
    kilogram piece inch centimetre can pack clove whole large medium
    small leaf pound ounce pint fluid_ounce quart gallon sprig
  ).sort.freeze
end
