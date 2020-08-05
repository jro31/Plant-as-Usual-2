require 'rails_helper'

describe IngredientHelper do
  helper do
    def user_signed_in?
      current_user.present?
    end
  end

  let!(:current_user) { create(:user, dark_mode: true) }

  describe '#ingredient_input_collection' do
    let(:units) { {can: 'Can', centimetre: 'Centimetre', clove: 'Clove', cup: 'Cup'} }
    context 'is_unit_column? is true' do
      it 'returns an array of units' do
        expect(ingredient_input_collection('unit', units)).to eq(
          [[:can, 'Can'], [:centimetre, "Centimetre"], [:clove, "Clove"], [:cup, "Cup"]]
        )
      end
    end

    context 'is_unit_column? is false' do
      it 'returns false' do
        expect(ingredient_input_collection('preparation', units)).to eq(false)
      end
    end
  end

  describe '#ingredient_label_method' do
    context 'is_unit_column? is true' do
      it { expect(ingredient_label_method('unit')).to eq(:second) }
    end

    context 'is_unit_column? is false' do
      it { expect(ingredient_label_method('preparation')).to eq(nil) }
    end
  end

  describe '#ingredient_value_method' do
    context 'is_unit_column? is true' do
      it { expect(ingredient_value_method('unit')).to eq(:first) }
    end

    context 'is_unit_column? is false' do
      it { expect(ingredient_value_method('preparation')).to eq(nil) }
    end
  end

  describe '#ingredient_input_label' do
    context 'is_optional_column? is true' do
      it { expect(ingredient_input_label('optional')).to eq('This ingredient is optional') }
    end

    context 'is_optional_column? is false' do
      it { expect(ingredient_input_label('unit')).to eq(false) }
    end
  end

  describe '#ingredient_input_placeholder' do
    context 'is_unit_column? is true' do
      it { expect(ingredient_input_placeholder('unit')).to eq(false) }
    end

    context 'is_optional_column? is true' do
      it { expect(ingredient_input_placeholder('optional')).to eq(false) }
    end

    context 'neither is_unit_column? or is_optional_column? are true' do
      context 'is_amount_column? is true' do
        it { expect(ingredient_input_placeholder('amount')).to eq('Amount (optional)') }
      end

      context 'is_preparation_column? is true' do
        it { expect(ingredient_input_placeholder('preparation')).to eq('Preparation (optional)') }
      end

      context 'column is food' do
        it { expect(ingredient_input_placeholder('food')).to eq('Ingredient') }
      end
    end
  end

  describe '#ingredient_input_prompt' do
    context 'is_unit_column? is true' do
      it { expect(ingredient_input_prompt('unit')).to eq('Measurement (optional)') }
    end

    context 'is_unit_column? is false' do
      it { expect(ingredient_input_prompt('food')).to eq(false) }
    end
  end
end
