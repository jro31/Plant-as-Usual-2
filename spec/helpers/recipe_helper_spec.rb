require 'rails_helper'

describe RecipeHelper do
  helper do
    def user_signed_in?
      current_user.present?
    end
  end

  let!(:current_user) { create(:user, dark_mode: true) }

  describe '#no_recipes_headline_text' do
    context 'recipe filter is user_is_owner' do
      it { expect(no_recipes_headline_text('user_is_owner')).to eq('Nothing but sadness here') }
    end

    context 'recipe filter is user_favourites' do
      it { expect(no_recipes_headline_text('user_favourites')).to eq("You haven't favourited any recipes yet") }
    end

    context 'recipe filter is something else' do
      it { expect(no_recipes_headline_text('tie_me_kangaroo_down_sport')).to eq('No results 😳') }
    end

    context 'recipe filter is an empty string' do
      it { expect(no_recipes_headline_text('')).to eq('No results 😳') }
    end

    context 'recipe filter is nil' do
      it { expect(no_recipes_headline_text(nil)).to eq('No results 😳') }
    end
  end
end
