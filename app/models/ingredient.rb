class Ingredient < ApplicationRecord
  belongs_to :recipe

  USER_EDITABLE_COLUMNS = {
    amount: 'amount',
    unit: 'unit',
    food: 'food',
    preparation: 'preparation',
    optional: 'optional'
  }

  UNIT_KEYS = %w(
    gram millilitre pinch splash teaspoon tablespoon cup dash litre
    kilogram piece inch centimetre can pack clove whole large medium
    small leaf pound ounce pint fluid_ounce quart gallon sprig handful
    block slice dollop tin jar
  ).sort.freeze

  SINGULAR_UNIT_AMOUNTS = [
    '1', 'one', 'a', 'an', 'quarter', 'half', 'a quarter', 'a half'
  ].sort.freeze

  validates_presence_of :food, on: :update

  before_validation :replace_empty_strings_with_nil

  class << self
    def ordered_editable_column_keys
      self::USER_EDITABLE_COLUMNS.keys
    end

    def ordered_editable_column_values
      self::USER_EDITABLE_COLUMNS.values
    end

    def user_facing_editable_column_names
      {
        self::USER_EDITABLE_COLUMNS[:amount] => 'Amount',
        self::USER_EDITABLE_COLUMNS[:unit] => 'Measurement',
        self::USER_EDITABLE_COLUMNS[:food] => 'Ingredient',
        self::USER_EDITABLE_COLUMNS[:preparation] => 'Preparation',
        self::USER_EDITABLE_COLUMNS[:optional] => 'This ingredient is optional'
      }
    end

    def ordered_display_rows
      [self::USER_EDITABLE_COLUMNS[:food], self::USER_EDITABLE_COLUMNS[:preparation]]
    end

    def units_humanized
      units_humanized = {}
      self::UNIT_KEYS.each do |unit_key|
        units_humanized[unit_key.to_sym] = unit_key.humanize
      end
      units_humanized
    end

    def units_pluralized
      units_pluralized = {}
      self::UNIT_KEYS.each do |unit_key|
        units_pluralized[unit_key.to_sym] = case unit_key
                                            when 'leaf'
                                              'leaves'.humanize
                                            when 'large', 'medium', 'small', 'whole'
                                              unit_key.humanize
                                            else
                                              unit_key.humanize.pluralize
                                            end
      end
      units_pluralized
    end

    def inhuman_units
      inhuman_units = {}
      self::UNIT_KEYS.each do |unit_key|
        inhuman_units[unit_key.to_sym] = unit_key
      end
      inhuman_units
    end
  end

  private

  def replace_empty_strings_with_nil
    self.amount = nil unless self.amount.present?
    self.unit = nil unless self.unit.present?
    self.preparation = nil unless self.preparation.present?
  end
end
