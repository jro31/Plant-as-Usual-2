require 'rails_helper'

RSpec.describe Recipe, type: :model do
  it { should belong_to :user }
  it { should have_many :ingredients }

  describe 'something' do
    let(:recipe) { create(:recipe) }
    it '' do
      puts recipe.name
      puts recipe.process
      puts recipe.cooking_time_minutes
    end
  end
end
