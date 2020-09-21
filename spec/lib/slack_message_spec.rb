require 'rails_helper'

describe SlackMessage do
  describe '#post_to_slack' do
    subject { SlackMessage.post_to_slack(message, channels: channels, nature: nature) }
    let(:message) { 'Test message' }
    let(:channels) { ['test'] }
    let(:nature) { 'celebrate' }
    context 'message string is present' do
      context 'channels exist' do
        context 'one channel is given' do
          context 'the channel is test' do
            context 'nature is given' do
              context 'nature is celebrate' do
                it 'finds a webhook url and sends the correct message' do
                  expect(Slack::Notifier).to receive(:new).with(/https:\/\/hooks.slack.com\/services\//).once.and_call_original
                  expect_any_instance_of(Slack::Notifier).to receive(:ping).with('🎉🎉 Test message 🎉🎉').once
                  subject
                end
              end

              context 'nature is congratulate' do
                let(:nature) { 'congratulate' }
                it 'sends the correct message' do
                  expect_any_instance_of(Slack::Notifier).to receive(:ping).with('👍👍 Test message 👍👍').once
                  subject
                end
              end

              context 'nature is inform' do
                let(:nature) { 'inform' }
                it 'sends the correct message' do
                  expect_any_instance_of(Slack::Notifier).to receive(:ping).with('📂📂 Test message 📂📂').once
                  subject
                end
              end

              context 'nature is setback' do
                let(:nature) { 'setback' }
                it 'sends the correct message' do
                  expect_any_instance_of(Slack::Notifier).to receive(:ping).with('🤮🤮 Test message 🤮🤮').once
                  subject
                end
              end

              context 'nature is chastise' do
                let(:nature) { 'chastise' }
                it 'sends the correct message' do
                  expect_any_instance_of(Slack::Notifier).to receive(:ping).with('🖕🖕 Test message 🖕🖕').once
                  subject
                end
              end

              context 'nature is disaster' do
                let(:nature) { 'disaster' }
                it 'sends the correct message' do
                  expect_any_instance_of(Slack::Notifier).to receive(:ping).with('🥺🔫 Test message 🥺🔫').once
                  subject
                end
              end

              context 'nature is surprise' do
                let(:nature) { 'shock' }
                it 'sends the correct message' do
                  expect_any_instance_of(Slack::Notifier).to receive(:ping).with('🙉🙉 Test message 🙉🙉').once
                  subject
                end
              end

              context 'nature is surprise' do
                let(:nature) { 'surprise' }
                it 'sends the correct message' do
                  expect_any_instance_of(Slack::Notifier).to receive(:ping).with('😮😮 Test message 😮😮').once
                  subject
                end
              end

              context 'nature is something else' do
                let(:nature) { '' }
                it 'sends the correct message' do
                  expect_any_instance_of(Slack::Notifier).to receive(:ping).with('🤨🤨 Test message 🤨🤨').once
                  subject
                end
              end

              context 'nature is nil' do
                let(:nature) { nil }
                it 'finds a webhook url and sends the correct message' do
                  expect(Slack::Notifier).to receive(:new).with(instance_of(String)).once.and_call_original
                  expect_any_instance_of(Slack::Notifier).to receive(:ping).with('🤨🤨 Test message 🤨🤨').once
                  subject
                end
              end
            end

            context 'nature is not given' do
              subject { SlackMessage.post_to_slack(message, channels: channels) }
              it 'finds a webhook url and sends the correct message' do
                expect(Slack::Notifier).to receive(:new).with(instance_of(String)).once.and_call_original
                expect_any_instance_of(Slack::Notifier).to receive(:ping).with('🤨🤨 Test message 🤨🤨').once
                subject
              end
            end

            context 'nature is not given as a string' do
              let(:nature) { 123 }
              it 'finds a webhook url and sends the correct message' do
                expect(Slack::Notifier).to receive(:new).with(instance_of(String)).once.and_call_original
                expect_any_instance_of(Slack::Notifier).to receive(:ping).with('🤨🤨 Test message 🤨🤨').once
                subject
              end
            end
          end

          context 'the channel is general' do
            let(:channels) { ['general'] }
            it 'finds a webhook url and sends the correct message' do
              expect(Slack::Notifier).to receive(:new).with(/https:\/\/hooks.slack.com\/services\//).once.and_call_original
              expect_any_instance_of(Slack::Notifier).to receive(:ping).with('🎉🎉 Test message 🎉🎉').once
              subject
            end
          end

          context 'the channel is jethro' do
            let(:channels) { ['jethro'] }
            it 'finds a webhook url and sends the correct message' do
              expect(Slack::Notifier).to receive(:new).with(/https:\/\/hooks.slack.com\/services\//).once.and_call_original
              expect_any_instance_of(Slack::Notifier).to receive(:ping).with('🎉🎉 Test message 🎉🎉').once
              subject
            end
          end

          context 'the channel is something else' do
            let(:channels) { ['wtf'] }
            it 'throws an error' do
              expect { subject }.to raise_error(SlackMessage::IncorrectSlackRoomError)
            end
          end
        end

        context 'multiple channels are given' do
          context 'both channels exist' do
            let(:channels) { ['test', 'general'] }
            it 'finds a webhook url two times' do
              allow_any_instance_of(Slack::Notifier).to receive(:ping).and_return(true)
              expect(Slack::Notifier).to receive(:new).with(/https:\/\/hooks.slack.com\/services\//).twice.and_call_original
              subject
            end
          end

          context 'one channel does not exist' do
            let(:channels) { ['test', 'wtf'] }
            it 'throws an error' do
              expect { subject }.to raise_error(SlackMessage::IncorrectSlackRoomError)
            end
          end
        end
      end

      context 'channels do not exist' do
        context 'channels are empty array' do
          let(:channels) { [] }
          it 'finds a webhook url and sends the correct message' do
            expect(Slack::Notifier).to receive(:new).with(/https:\/\/hooks.slack.com\/services\//).once.and_call_original
            expect_any_instance_of(Slack::Notifier).to receive(:ping).with('🎉🎉 Test message 🎉🎉').once
            subject
          end
        end

        context 'channels are nil' do
          let(:channels) { nil }
          it 'finds a webhook url and sends the correct message' do
            expect(Slack::Notifier).to receive(:new).with(/https:\/\/hooks.slack.com\/services\//).once.and_call_original
            expect_any_instance_of(Slack::Notifier).to receive(:ping).with('🎉🎉 Test message 🎉🎉').once
            subject
          end
        end
      end

      context 'channels are not given' do
        subject { SlackMessage.post_to_slack(message, nature: nature) }
        it 'finds a webhook url and sends the correct message' do
          expect(Slack::Notifier).to receive(:new).with(/https:\/\/hooks.slack.com\/services\//).once.and_call_original
          expect_any_instance_of(Slack::Notifier).to receive(:ping).with('🎉🎉 Test message 🎉🎉').once
          subject
        end

        context 'nature is not given' do
          subject { SlackMessage.post_to_slack(message) }
          it 'finds a webhook url and sends the correct message' do
            expect(Slack::Notifier).to receive(:new).with(/https:\/\/hooks.slack.com\/services\//).once.and_call_original
            expect_any_instance_of(Slack::Notifier).to receive(:ping).with('🤨🤨 Test message 🤨🤨').once
            subject
          end
        end
      end

      context 'channels are not given as an array' do
        let(:channels) { {general: 'general'} }
        it 'finds a webhook url and sends the correct message' do
          expect(Slack::Notifier).to receive(:new).with(/https:\/\/hooks.slack.com\/services\//).once.and_call_original
          expect_any_instance_of(Slack::Notifier).to receive(:ping).with('🎉🎉 Test message 🎉🎉').once
          subject
        end
      end
    end

    context 'message is an empry string' do
      let(:message) { '' }
      it 'does not find any webhooks or send any messages' do
        expect(Slack::Notifier).to receive(:new).with(/https:\/\/hooks.slack.com\/services\//).never
        expect_any_instance_of(Slack::Notifier).to receive(:ping).never
        subject
      end
    end

    context 'message is not a string' do
      let(:message) { 123 }
      it 'does not find any webhooks or send any messages' do
        expect(Slack::Notifier).to receive(:new).with(/https:\/\/hooks.slack.com\/services\//).never
        expect_any_instance_of(Slack::Notifier).to receive(:ping).never
        subject
      end
    end

    context 'message is nil' do
      let(:message) { nil }
      it 'does not find any webhooks or send any messages' do
        expect(Slack::Notifier).to receive(:new).with(/https:\/\/hooks.slack.com\/services\//).never
        expect_any_instance_of(Slack::Notifier).to receive(:ping).never
        subject
      end
    end
  end
end
