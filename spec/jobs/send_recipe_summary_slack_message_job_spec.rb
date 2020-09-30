require 'rails_helper'

describe SendRecipeSummarySlackMessageJob do
  describe '#perform' do
    it 'calls post_to_slack' do
      expect(SlackMessage).to receive(:post_to_slack).with('There are no awaiting approval or incomplete recipes', nature: 'inform').once
      SendRecipeSummarySlackMessageJob.perform_now
    end
  end
end
