desc "These tasks are called by the Heroku scheduler add-on"

task :update_highlighted_recipes => :environment do
  puts "Calling update highlighted recipes job..."
  UpdateHighlightedRecipesJob.perform_later
  puts "Done!"
end
