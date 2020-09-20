class SlackMessage
  class IncorrectSlackRoomError < StandardError; end

  def self.post_to_slack(message, channels: ['general'], nature: nil)
    return unless message.present? && message.is_a?(String)
    raise SlackMessage::IncorrectSlackRoomError if channels.map{ |channel| webhook_url(channel)}.include?(nil)

    channels.each do |channel|
      notifier = Slack::Notifier.new(webhook_url(channel))
      notifier.ping(formatted_message(message, nature))
    end
  end

  private

  def self.webhook_url(channel)
    ENV["SLACK_#{channel.upcase}_WEBHOOK_URL"]
  end

  def self.formatted_message(message, nature)
    emoji = message_emoji(nature).length >= 2 ? message_emoji(nature) : "#{message_emoji(nature)}#{message_emoji(nature)}"

    "#{emoji} #{message} #{emoji}"
  end

  def self.message_emoji(nature)
    @emoji ||= case nature
               when 'celebrate'
                 '🎉'
               when 'congratulate'
                 '👍'
               when 'inform'
                 '📂'
               when 'setback'
                 '🤮'
               when 'chastise'
                 '🖕'
               when 'disaster'
                 '🥺🔫'
               when 'surprise'
                 '🙉'
               else
                 '🤷‍♂️'
               end
  end
end
