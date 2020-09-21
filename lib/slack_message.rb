class SlackMessage
  class IncorrectSlackRoomError < StandardError; end

  def self.post_to_slack(message, channels: nil, nature: nil)
    @channels = channels.present? && channels.is_a?(Array) ? channels : ['general']
    @nature = nature

    return unless message.present? && message.is_a?(String)
    raise SlackMessage::IncorrectSlackRoomError if @channels.map{ |channel| webhook_url(channel)}.include?(nil)

    @channels.each do |channel|
      notifier = Slack::Notifier.new(webhook_url(channel))
      notifier.ping(formatted_message(message))
    end
  end

  private

  def self.webhook_url(channel)
    ENV["SLACK_#{channel.upcase}_WEBHOOK_URL"]
  end

  def self.formatted_message(message)
    emoji = message_emoji.length >= 2 ? message_emoji : "#{message_emoji}#{message_emoji}"

    "#{emoji} #{message} #{emoji}"
  end

  def self.message_emoji
    case @nature
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
    when 'shock'
      '🙉'
    when 'surprise'
      '😮'
    else
      '🤨'
    end
  end
end
