class SendRecipeSummarySlackMessageJob < ApplicationJob
  def perform
    @awaiting_approval_count = Recipe.awaiting_approval.count
    @incomplete_count = Recipe.incomplete.count
    SendSlackMessageJob.perform_later(message, nature: 'inform')
  end

  private

  def message
    if @awaiting_approval_count.zero? && @incomplete_count.zero?
      "There are no awaiting approval or incomplete recipes"
    else
      "There #{is_or_are(@awaiting_approval_count)} #{no_or_number(@awaiting_approval_count)} #{'recipe'.pluralize(@awaiting_approval_count)} awaiting approval, and #{no_or_number(@incomplete_count)} incomplete #{'recipe'.pluralize(@incomplete_count)} #{admin_url}"
    end
  end

  def is_or_are(amount)
    amount == 1 ? 'is' : 'are'
  end

  def no_or_number(amount)
    amount.zero? ? 'no' : amount
  end

  def admin_url
    UrlMaker.new('admin').full_url
  end
end
