require 'rails_helper'

describe SendRecipeSummarySlackMessageJob do
  describe '#perform' do
    subject { SendRecipeSummarySlackMessageJob.perform_now }
    let!(:imposter_recipe) { create(:recipe, state: :approved) }
    context 'awaiting_approval_count is zero' do
      context 'incomplete_count is zero' do
        it 'calls SendSlackMessageJob with the correct message' do
          expect(SendSlackMessageJob).to receive(:perform_later).with('There are no awaiting approval or incomplete recipes', nature: 'inform').once
          subject
        end
      end

      context 'incomplete_count is one' do
        let!(:incomplete_recipe) { create(:recipe, state: :incomplete) }
        it 'calls SendSlackMessageJob with the correct message' do
          expect(SendSlackMessageJob).to receive(:perform_later).with('There are no recipes awaiting approval, and 1 incomplete recipe https://www.plantasusual.com/admin', nature: 'inform').once
          subject
        end
      end

      context 'incomplete_count is two' do
        let!(:incomplete_recipe_1) { create(:recipe, state: :incomplete) }
        let!(:incomplete_recipe_2) { create(:recipe, state: :incomplete) }
        it 'calls SendSlackMessageJob with the correct message' do
          expect(SendSlackMessageJob).to receive(:perform_later).with('There are no recipes awaiting approval, and 2 incomplete recipes https://www.plantasusual.com/admin', nature: 'inform').once
          subject
        end
      end
    end

    context 'awaiting_approval_count is one' do
      let!(:awaiting_approval_recipe) { create(:recipe, state: :awaiting_approval) }
      context 'incomplete_count is zero' do
        it 'calls SendSlackMessageJob with the correct message' do
          expect(SendSlackMessageJob).to receive(:perform_later).with('There is 1 recipe awaiting approval, and no incomplete recipes https://www.plantasusual.com/admin', nature: 'inform').once
          subject
        end
      end

      context 'incomplete_count is one' do
        let!(:incomplete_recipe) { create(:recipe, state: :incomplete) }
        it 'calls SendSlackMessageJob with the correct message' do
          expect(SendSlackMessageJob).to receive(:perform_later).with('There is 1 recipe awaiting approval, and 1 incomplete recipe https://www.plantasusual.com/admin', nature: 'inform').once
          subject
        end
      end

      context 'incomplete_count is two' do
        let!(:incomplete_recipe_1) { create(:recipe, state: :incomplete) }
        let!(:incomplete_recipe_2) { create(:recipe, state: :incomplete) }
        it 'calls SendSlackMessageJob with the correct message' do
          expect(SendSlackMessageJob).to receive(:perform_later).with('There is 1 recipe awaiting approval, and 2 incomplete recipes https://www.plantasusual.com/admin', nature: 'inform').once
          subject
        end
      end
    end

    context 'awaiting_approval_count is two' do
      let!(:awaiting_approval_recipe_1) { create(:recipe, state: :awaiting_approval) }
      let!(:awaiting_approval_recipe_2) { create(:recipe, state: :awaiting_approval) }
      context 'incomplete_count is zero' do
        it 'calls SendSlackMessageJob with the correct message' do
          expect(SendSlackMessageJob).to receive(:perform_later).with('There are 2 recipes awaiting approval, and no incomplete recipes https://www.plantasusual.com/admin', nature: 'inform').once
          subject
        end
      end

      context 'incomplete_count is one' do
        let!(:incomplete_recipe) { create(:recipe, state: :incomplete) }
        it 'calls SendSlackMessageJob with the correct message' do
          expect(SendSlackMessageJob).to receive(:perform_later).with('There are 2 recipes awaiting approval, and 1 incomplete recipe https://www.plantasusual.com/admin', nature: 'inform').once
          subject
        end
      end

      context 'incomplete_count is two' do
        let!(:incomplete_recipe_1) { create(:recipe, state: :incomplete) }
        let!(:incomplete_recipe_2) { create(:recipe, state: :incomplete) }
        it 'calls SendSlackMessageJob with the correct message' do
          expect(SendSlackMessageJob).to receive(:perform_later).with('There are 2 recipes awaiting approval, and 2 incomplete recipes https://www.plantasusual.com/admin', nature: 'inform').once
          subject
        end
      end
    end
  end
end
