require 'rails_helper'

describe Ingredient, type: :model do
  it { should belong_to :recipe }

  describe 'USER_EDITABLE_COLUMNS' do
    it 'returns a hash of editable columns' do
      expect(Ingredient::USER_EDITABLE_COLUMNS).to eq({
        amount: 'amount',
        unit: 'unit',
        food: 'food',
        preparation: 'preparation',
        optional: 'optional'
      })
    end
  end

  describe 'UNIT_KEYS' do
    it 'returns the unit keys in alphabetical order' do
      expect(Ingredient::UNIT_KEYS).to eq(
        %w(
          block can centimetre clove cup dash dollop fluid_ounce gallon gram handful inch jar kilogram
          large leaf litre medium millilitre ounce pack piece pinch pint pound quart slice small
          splash sprig tablespoon teaspoon tin whole
        )
      )
    end
  end

  describe 'SINGULAR_UNIT_AMOUNTS' do
    it 'returns the singular unit amounts in alphabetical order' do
      expect(Ingredient::SINGULAR_UNIT_AMOUNTS).to eq([
        '1', 'a', 'a half', 'a quarter', 'an', 'half', 'one', 'quarter'
      ])
    end
  end

  describe 'validations' do
    describe 'validates presence of food' do
      context 'on create' do
        context 'food is present' do
          subject { build(:ingredient, food: nil) }
          it { expect(subject).to be_valid }
        end

        context 'food is not present' do
          subject { build(:ingredient, food: 'nuts') }
          it { expect(subject).to be_valid }
        end
      end

      context 'on update' do
        subject { create(:ingredient) }
        context 'food is present' do
          it 'is valid' do
            subject.food = 'nuts'
            expect(subject).to be_valid
          end
        end

        context 'food is not present' do
          it 'is not valid' do
            subject.food = nil
            expect(subject).not_to be_valid
          end
        end
      end
    end
  end

  describe 'callbacks' do
    describe 'before_validation' do
      describe '#replace_empty_strings_with_nil' do
        describe 'on create' do
          describe 'amount' do
            subject { build(:ingredient, amount: '') }
            it 'saves as nil' do
              subject.save
              expect(subject.amount).to eq(nil)
            end
          end

          describe 'unit' do
            subject { build(:ingredient, unit: '') }
            it 'saves as nil' do
              subject.save
              expect(subject.unit).to eq(nil)
            end
          end

          describe 'preparation' do
            subject { build(:ingredient, preparation: '') }
            it 'saves as nil' do
              subject.save
              expect(subject.preparation).to eq(nil)
            end
          end
        end

        describe 'on update' do
          subject { create(:ingredient) }
          describe 'amount' do
            it 'saves as nil' do
              subject.update(amount: '')
              expect(subject.amount).to eq(nil)
            end
          end

          describe 'unit' do
            it 'saves as nil' do
              subject.update(unit: '')
              expect(subject.unit).to eq(nil)
            end
          end

          describe 'preparation' do
            it 'saves as nil' do
              subject.update(preparation: '')
              expect(subject.preparation).to eq(nil)
            end
          end
        end
      end
    end
  end

  describe '#ordered_editable_column_keys' do
    it 'returns the keys in the display order' do
      expect(Ingredient.ordered_editable_column_keys).to eq(%i(amount unit food preparation optional))
    end
  end

  describe '#ordered_editable_column_values' do
    it 'returns the values in the display order' do
      expect(Ingredient.ordered_editable_column_values).to eq(%w(amount unit food preparation optional))
    end
  end

  describe '#user_facing_editable_column_names' do
    it 'returns the user-facing column names' do
      expect(Ingredient.user_facing_editable_column_names).to eq(
        {
          'amount' => 'Amount',
          'unit' => 'Measurement',
          'food' => 'Ingredient',
          'preparation' => 'Preparation',
          'optional' => 'This ingredient is optional'
        }
      )
    end
  end

  describe '#ordered_display_rows' do
    it 'returns the two display row names' do
      expect(Ingredient.ordered_display_rows).to eq(%w(food preparation))
    end
  end

  describe '#units_humanized' do
    it 'returns a hash of units humanized' do
      expect(Ingredient.units_humanized).to eq(
        {
          block: 'Block',
          can: 'Can',
          centimetre: 'Centimetre',
          clove: 'Clove',
          cup: 'Cup',
          dash: 'Dash',
          dollop: 'Dollop',
          fluid_ounce: 'Fluid ounce',
          gallon: 'Gallon',
          gram: 'Gram',
          handful: 'Handful',
          inch: 'Inch',
          jar: 'Jar',
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
          slice: 'Slice',
          small: 'Small',
          splash: 'Splash',
          sprig: 'Sprig',
          tablespoon: 'Tablespoon',
          teaspoon: 'Teaspoon',
          tin: 'Tin',
          whole: 'Whole'
        }
      )
    end
  end

  describe '#units_pluralized' do
    it 'returns a hash of units humanized and pluralized' do
      expect(Ingredient.units_pluralized).to eq(
        {
          block: 'Blocks',
          can: 'Cans',
          centimetre: 'Centimetres',
          clove: 'Cloves',
          cup: 'Cups',
          dash: 'Dashes',
          dollop: 'Dollops',
          fluid_ounce: 'Fluid ounces',
          gallon: 'Gallons',
          gram: 'Grams',
          handful: 'Handfuls',
          inch: 'Inches',
          jar: 'Jars',
          kilogram: 'Kilograms',
          large: 'Large',
          leaf: 'Leaves',
          litre: 'Litres',
          medium: 'Medium',
          millilitre: 'Millilitres',
          ounce: 'Ounces',
          pack: 'Packs',
          piece: 'Pieces',
          pinch: 'Pinches',
          pint: 'Pints',
          pound: 'Pounds',
          quart: 'Quarts',
          slice: 'Slices',
          small: 'Small',
          splash: 'Splashes',
          sprig: 'Sprigs',
          tablespoon: 'Tablespoons',
          teaspoon: 'Teaspoons',
          tin: 'Tins',
          whole: 'Whole'
        }
      )
    end
  end

  describe '#inhuman_units' do
    it 'returns a hash of inhuman units' do
      expect(Ingredient.inhuman_units).to eq(
        {
          block: 'block',
          can: 'can',
          centimetre: 'centimetre',
          clove: 'clove',
          cup: 'cup',
          dash: 'dash',
          dollop: 'dollop',
          fluid_ounce: 'fluid_ounce',
          gallon: 'gallon',
          gram: 'gram',
          handful: 'handful',
          inch: 'inch',
          jar: 'jar',
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
          slice: 'slice',
          small: 'small',
          splash: 'splash',
          sprig: 'sprig',
          tablespoon: 'tablespoon',
          teaspoon: 'teaspoon',
          tin: 'tin',
          whole: 'whole'
        }
      )
    end
  end
end
