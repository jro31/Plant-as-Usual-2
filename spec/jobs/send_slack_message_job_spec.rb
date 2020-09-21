require 'rails_helper'

describe SendSlackMessageJob do
  describe '#perform' do
    let(:message) { 'Test message' }
    let(:channels) { ['test'] }
    let(:nature) { 'disaster' }
    context 'channels and nature are not passed-in' do
      subject { SendSlackMessageJob.perform_now(message) }
      it 'calls post_to_slack' do
        expect(SlackMessage).to receive(:post_to_slack).with('Test message', channels: nil, nature: nil).once
        subject
      end
    end

    context 'channels is passed-in' do
      subject { SendSlackMessageJob.perform_now(message, channels: channels) }
      it 'calls post_to_slack' do
        expect(SlackMessage).to receive(:post_to_slack).with('Test message', channels: ['test'], nature: nil).once
        subject
      end
    end

    context 'nature is passed-in' do
      subject { SendSlackMessageJob.perform_now(message, nature: nature) }
      it 'calls post_to_slack' do
        expect(SlackMessage).to receive(:post_to_slack).with('Test message', channels: nil, nature: 'disaster').once
        subject
      end
    end

    context 'channels and nature are passed-in' do
      subject { SendSlackMessageJob.perform_now(message, nature: nature, channels: channels) }
      it 'calls post_to_slack' do
        expect(SlackMessage).to receive(:post_to_slack).with('Test message', channels: ['test'], nature: 'disaster').once
        subject
      end
    end
  end
end
