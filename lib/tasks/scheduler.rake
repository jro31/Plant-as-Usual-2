desc "These tasks are called by the Heroku scheduler add-on"

task :update_highlighted_recipes => :environment do
  puts "Updating highlighted recipes..."
  Recipe.update_highlighted_recipes
  puts "Done!"
end
