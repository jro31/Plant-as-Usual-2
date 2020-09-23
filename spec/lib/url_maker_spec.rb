require 'rails_helper'

describe UrlMaker do
  describe '#full_url' do
    let(:recipe) { create(:recipe) }
    let(:ingredient) { create(:ingredient, recipe: recipe) }
    context 'route has no passed-in ids' do
      let(:named_route) { 'admin' }
      context 'object_ids is not given' do
        it { expect(UrlMaker.new(named_route).full_url).to eq('https://www.plantasusual.com/admin') }
      end

      context 'object_ids is nil' do
        it { expect(UrlMaker.new(named_route, nil).full_url).to eq('https://www.plantasusual.com/admin') }
      end
    end

    context 'route has one passed-in id' do
      it { expect(UrlMaker.new('recipe', recipe.id).full_url).to eq("https://www.plantasusual.com/recipes/#{recipe.id}") }
    end

    context 'route has two passed-in ids' do
      it { expect(UrlMaker.new('recipe_ingredient', recipe.id, ingredient.id).full_url).to eq("https://www.plantasusual.com/recipes/#{recipe.id}/ingredients/#{ingredient.id}") }
    end
  end
end
