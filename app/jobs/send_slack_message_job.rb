class SendSlackMessageJob < ApplicationJob
  def perform(message, channels: nil, nature: nil)
    SlackMessage.post_to_slack(message, channels: channels, nature: nature)
  end
end
