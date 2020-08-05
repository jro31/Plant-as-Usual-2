require 'rails_helper'

describe User, type: :model do
  it { should have_many :recipes }

  let(:user) { create(:user) }

  describe 'destroying a user destroys their recipes' do
    let!(:recipe) { create(:recipe, id: 999, user: user) }
    it 'destroys the recipe' do
      expect(Recipe.find(999)).to eq(recipe)
      user.destroy
      expect { Recipe.find(999) }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
