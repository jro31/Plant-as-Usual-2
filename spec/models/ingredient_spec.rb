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
          can centimetre clove cup dash fluid_ounce gallon gram inch kilogram
          large leaf litre medium millilitre ounce pack piece pinch pint pound quart small
          splash sprig tablespoon teaspoon whole
        )
      )
    end
  end

  describe 'callbacks' do
    describe 'before_save' do
      describe '#set_amount_as_float' do
        subject { create(:ingredient, amount: 'ten') }
        context 'amount is nil' do
          context 'amount_as_float already exists' do
            it 'reverts amount_as_float to nil' do
              expect(subject.amount_as_float).to eq(10.0)
              subject.update(amount: nil)
              expect(subject.amount_as_float).to eq(nil)
            end
          end

          context 'amount_as_float does not already exist' do
            subject { create(:ingredient, amount: nil) }
            it 'does not change amount_as_float' do
              expect(subject.amount_as_float).to eq(nil)
              subject.update(amount: nil)
              expect(subject.amount_as_float).to eq(nil)
            end
          end
        end

        context 'amount is not nil' do
          context 'amount can be changed into a float' do
            context 'amount is numeric' do
              context '100' do
                it 'sets amount_as_float' do
                  subject.update(amount: '100')
                  expect(subject.amount_as_float).to eq(100.0)
                end
              end

              context '12345' do
                it 'sets amount_as_float' do
                  subject.update(amount: '12345')
                  expect(subject.amount_as_float).to eq(12345.0)
                end
              end

              context '1234567.89' do
                it 'sets amount_as_float' do
                  subject.update(amount: '1234567.89')
                  expect(subject.amount_as_float).to eq(1234567.89)
                end
              end

              context '100.0' do
                it 'sets amount_as_float' do
                  subject.update(amount: '100.0')
                  expect(subject.amount_as_float).to eq(100.0)
                end
              end

              context '0.01' do
                it 'sets amount_as_float' do
                  subject.update(amount: '0.01')
                  expect(subject.amount_as_float).to eq(0.01)
                end
              end

              context '1.23456789' do
                it 'sets amount_as_float' do
                  subject.update(amount: '1.23456789')
                  expect(subject.amount_as_float).to eq(1.23456789)
                end
              end
            end

            context 'amount is text' do
              context 'one' do
                it 'sets amount_as_float' do
                  subject.update(amount: 'one')
                  expect(subject.amount_as_float).to eq(1.0)
                end
              end

              context 'one hundred' do
                it 'sets amount_as_float' do
                  subject.update(amount: 'one hundred')
                  expect(subject.amount_as_float).to eq(100.0)
                end
              end

              context 'a hundred' do
                it 'sets amount_as_float' do
                  subject.update(amount: 'a hundred')
                  expect(subject.amount_as_float).to eq(100.0)
                end
              end

              context 'one hundred thirty-three' do
                it 'sets amount_as_float' do
                  subject.update(amount: 'one hundred thirty-three')
                  expect(subject.amount_as_float).to eq(133.0)
                end
              end

              context 'a hundred and twenty seven' do
                it 'sets amount_as_float' do
                  subject.update(amount: 'a hundred and twenty seven')
                  expect(subject.amount_as_float).to eq(127.0)
                end
              end

              context 'a thousand six-hundred and fifty five' do
                xit 'sets amount_as_float' do # Fails. Have opened issue with gem.
                  subject.update(amount: 'a thousand six-hundred and fifty five')
                  expect(subject.amount_as_float).to eq(1655.0)
                end
              end

              context 'one thousand' do
                it 'sets amount_as_float' do
                  subject.update(amount: 'one thousand')
                  expect(subject.amount_as_float).to eq(1000.0)
                end
              end

              context 'one thousand and ten' do
                it 'sets amount_as_float' do
                  subject.update(amount: 'one thousand and ten')
                  expect(subject.amount_as_float).to eq(1010.0)
                end
              end

              context 'one thousand two hundred' do
                it 'sets amount_as_float' do
                  subject.update(amount: 'one thousand two hundred')
                  expect(subject.amount_as_float).to eq(1200.0)
                end
              end

              context 'one thousand two hundred and ten' do
                it 'sets amount_as_float' do
                  subject.update(amount: 'one thousand two hundred and ten')
                  expect(subject.amount_as_float).to eq(1210.0)
                end
              end

              context 'one thousand two hundred and twenty four' do
                it 'sets amount_as_float' do
                  subject.update(amount: 'one thousand two hundred twenty four')
                  expect(subject.amount_as_float).to eq(1224.0)
                end
              end
            end
          end

          context 'amount cannot be changed into a float' do
            context 'amount_as_float already exists' do
              it 'reverts amount_as_float to nil' do
                expect(subject.amount_as_float).to eq(10.0)
                subject.update(amount: 'some')
                expect(subject.amount_as_float).to eq(nil)
              end

              it 'reverts amount_as_float to nil' do
                expect(subject.amount_as_float).to eq(10.0)
                subject.update(amount: 'a handful')
                expect(subject.amount_as_float).to eq(nil)
              end
            end

            context 'amount_as_float does not already exist' do
              subject { create(:ingredient, amount: nil) }
              it 'does not change amount_as_float' do
                expect(subject.amount_as_float).to eq(nil)
                subject.update(amount: 'a bit')
                expect(subject.amount_as_float).to eq(nil)
              end
            end
          end
        end
      end
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

  describe '#units_pluralized' do
    it 'returns a hash of units humanized and pluralized' do
      expect(Ingredient.units_pluralized).to eq(
        {
          can: 'Cans',
          centimetre: 'Centimetres',
          clove: 'Cloves',
          cup: 'Cups',
          dash: 'Dashes',
          fluid_ounce: 'Fluid ounces',
          gallon: 'Gallons',
          gram: 'Grams',
          inch: 'Inches',
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
          small: 'Small',
          splash: 'Splashes',
          sprig: 'Sprigs',
          tablespoon: 'Tablespoons',
          teaspoon: 'Teaspoons',
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
