require 'rails_helper'

describe Ingredient, type: :model do
  it { should belong_to :recipe }

  describe 'USER_EDITABLE_COLUMNS' do
    it 'returns a hash of editable columns' do
      # COMPLETE THIS
      expect(Ingredient::USER_EDITABLE_COLUMNS).to eq('')
    end
  end

  describe 'UNIT_KEYS' do
    it 'returns the unit keys in alphabetical order' do
      expect(Ingredient::UNIT_KEYS).to eq(
        %w(
          can centimetre clove cup dash fluid_ounce gallon gram inch kilogram
          large leaf litre medium millilitre ounce pack piece pinch pint pound quart small
          splash sprig tablespoon teaspoon whole
        )
      )
    end
  end

  describe 'callbacks' do
    describe 'before_validation' do
      describe '#numerify_amount' do
        # COMPLETE THIS
      end
    end
  end

  describe 'validations' do
    describe 'validates presence of food' do
      # COMPLETE THIS
    end
  end

  describe '#ordered_editable_column_keys' do
    it 'returns the keys in the display order' do
      expect(Ingredient.ordered_editable_column_keys).to eq([:amount, :unit, :food, :preparation, :optional])
    end
  end

  describe '#ordered_editable_column_values' do
    # COMPLETE THIS
  end

  describe '#user_facing_editable_column_names' do
    # COMPLETE THIS
  end

  describe '#units_humanized' do
    it 'returns a hash of units humanized' do
      expect(Ingredient.units_humanized).to eq(
        {
          can: 'Can',
          centimetre: 'Centimetre',
          clove: 'Clove',
          cup: 'Cup',
          dash: 'Dash',
          fluid_ounce: 'Fluid ounce',
          gallon: 'Gallon',
          gram: 'Gram',
          inch: 'Inch',
          kilogram: 'Kilogram',
          large: 'Large',
          leaf: 'Leaf',
          litre: 'Litre',
          medium: 'Medium',
          millilitre: 'Millilitre',
          ounce: 'Ounce',
          pack: 'Pack',
          piece: 'Piece',
          pinch: 'Pinch',
          pint: 'Pint',
          pound: 'Pound',
          quart: 'Quart',
          small: 'Small',
          splash: 'Splash',
          sprig: 'Sprig',
          tablespoon: 'Tablespoon',
          teaspoon: 'Teaspoon',
          whole: 'Whole'
        }
      )
    end
  end

  describe '#inhuman_units' do
    it 'returns a hash of inhuman units' do
      expect(Ingredient.inhuman_units).to eq(
        {
          can: 'can',
          centimetre: 'centimetre',
          clove: 'clove',
          cup: 'cup',
          dash: 'dash',
          fluid_ounce: 'fluid_ounce',
          gallon: 'gallon',
          gram: 'gram',
          inch: 'inch',
          kilogram: 'kilogram',
          large: 'large',
          leaf: 'leaf',
          litre: 'litre',
          medium: 'medium',
          millilitre: 'millilitre',
          ounce: 'ounce',
          pack: 'pack',
          piece: 'piece',
          pinch: 'pinch',
          pint: 'pint',
          pound: 'pound',
          quart: 'quart',
          small: 'small',
          splash: 'splash',
          sprig: 'sprig',
          tablespoon: 'tablespoon',
          teaspoon: 'teaspoon',
          whole: 'whole'
        }
      )
    end
  end
end
