desc "These tasks are called by the Heroku scheduler add-on"

task :update_highlighted_recipes => :environment do
  puts "Updating highlighted recipes..."
  Recipe.update_highlighted_recipes
  puts "Done!"
end

task :send_recipe_summary => :environment do
  puts "Sending recipe summary Slack message..."
  Recipe.send_recipe_summary_message_to_slack
  puts "Done!"
end
