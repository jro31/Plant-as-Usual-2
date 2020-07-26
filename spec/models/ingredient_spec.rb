require 'rails_helper'

describe Ingredient, type: :model do
  it { should belong_to :recipe }

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
