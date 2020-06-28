require 'rails_helper'

describe Recipe, type: :model do
  it { should belong_to :user }
  it { should have_many :ingredients }

  describe 'scopes' do
    let!(:incomplete_recipe) { create(:recipe, state: :incomplete) }
    let!(:awaiting_approval_recipe) { create(:recipe, state: :awaiting_approval) }
    let!(:approved_recipe) { create(:recipe, state: :approved) }
    let!(:approved_for_feature_recipe) { create(:recipe, state: :approved_for_feature) }
    let!(:approved_for_recipe_of_the_day_recipe) { create(:recipe, state: :approved_for_recipe_of_the_day) }
    let!(:declined_recipe) { create(:recipe, state: :declined) }
    let!(:hidden_recipe) { create(:recipe, state: :hidden) }

    describe '.approved' do
      subject { Recipe.approved }
      it { expect(subject).to include(approved_recipe, approved_for_feature_recipe, approved_for_recipe_of_the_day_recipe) }
      it { expect(subject).not_to include(incomplete_recipe, awaiting_approval_recipe, declined_recipe, hidden_recipe) }
    end

    describe '.approved_for_feature' do
      subject { Recipe.approved_for_feature }
      it { expect(subject).to include(approved_for_feature_recipe, approved_for_recipe_of_the_day_recipe) }
      it { expect(subject).not_to include(incomplete_recipe, awaiting_approval_recipe, approved_recipe, declined_recipe, hidden_recipe) }
    end

    describe '.approved_for_recipe_of_the_day' do
      subject { Recipe.approved_for_recipe_of_the_day }
      it { expect(subject).to include(approved_for_recipe_of_the_day_recipe) }
      it { expect(subject).not_to include(incomplete_recipe, awaiting_approval_recipe, approved_recipe, approved_for_feature_recipe, declined_recipe, hidden_recipe) }
    end

    describe '.awaiting_approval' do
      subject { Recipe.awaiting_approval }
      it { expect(subject).to include(awaiting_approval_recipe) }
      it { expect(subject).not_to include(incomplete_recipe, approved_recipe, approved_for_feature_recipe, approved_for_recipe_of_the_day_recipe, declined_recipe, hidden_recipe) }
    end

    describe '.not_hidden' do
      subject { Recipe.not_hidden }
      it { expect(subject).to include(incomplete_recipe, awaiting_approval_recipe, approved_recipe, approved_for_feature_recipe, approved_for_recipe_of_the_day_recipe, declined_recipe) }
      it { expect(subject).not_to include(hidden_recipe) }
    end
  end

  describe 'state machine' do
    # COMPLETE THIS
  end

  describe 'something' do
    context 'recipe' do
      let(:recipe) { create(:recipe) }
      it 'does something' do
        puts recipe.name
        puts recipe.process
      end
    end

    context 'recipe_with_ingredients' do
      let(:recipe_with_ingredients) { create(:recipe_with_ingredients) }
      it 'does something else' do
        puts recipe_with_ingredients.name
        puts recipe_with_ingredients.ingredients.first.food
        puts recipe_with_ingredients.ingredients.last.food
      end
    end
  end
end
