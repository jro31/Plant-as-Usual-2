require 'rails_helper'

describe UpdateHighlightedRecipesJob do
  describe '#perform' do
    subject { UpdateHighlightedRecipesJob.perform_now }
    it 'calls update_highlighted_recipes' do
      expect(Recipe).to receive(:update_highlighted_recipes).once
      subject
    end
  end
end
