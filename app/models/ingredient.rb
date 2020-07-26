class Ingredient < ApplicationRecord
  belongs_to :recipe

  UNIT_KEYS = %w(
    gram millilitre pinch splash teaspoon tablespoon cup dash litre
    kilogram piece inch centimetre can pack clove whole large medium
    small leaf pound ounce pint fluid_ounce quart gallon sprig
  ).sort.freeze

  def self.units_humanized
    units_humanized = {}
    self::UNIT_KEYS.each do |unit_key|
      units_humanized[unit_key.to_sym] = unit_key.humanize
    end
    units_humanized
  end

  def self.inhuman_units
    inhuman_units = {}
    self::UNIT_KEYS.each do |unit_key|
      inhuman_units[unit_key.to_sym] = unit_key
    end
    inhuman_units
  end
end
