class SendRecipeSummarySlackMessageJob < ApplicationJob
  def perform
    SlackMessage.post_to_slack(Recipe.recipe_summary_message, nature: 'inform')
  end
end
