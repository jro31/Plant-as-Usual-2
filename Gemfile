source 'https://rubygems.org'
ruby '2.6.3'

gem 'bootsnap', require: false
gem 'devise'
gem 'jbuilder', '~> 2.0'
gem 'pg', '~> 0.21'
gem 'puma'
gem 'rails', '6.0.1'
gem 'redis'

gem 'autoprefixer-rails'
gem 'font-awesome-sass', '~> 5.6.1'
gem 'sassc-rails'
gem 'simple_form'
gem 'uglifier'
gem 'webpacker'

gem 'haml'
gem 'pundit'
gem 'faker'
gem 'jquery-rails'
gem 'carrierwave'
gem 'fog-aws'
gem 'mini_magick'
gem 'figaro'
gem 'state_machines-activerecord'

group :development do
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'shoulda-matchers'
  gem 'rr', require: false
end

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'dotenv-rails'

  # Was getting an rspec bug (see https://github.com/rspec/rspec-rails/issues/2177). This was the fix until rSpec 4.0 is released:
  # gem 'rspec-rails', '~> 3.9.0'
  gem 'rspec-core', git: 'https://github.com/rspec/rspec-core'
  gem 'rspec-expectations', git: 'https://github.com/rspec/rspec-expectations'
  gem 'rspec-mocks', git: 'https://github.com/rspec/rspec-mocks'
  gem 'rspec-rails', git: 'https://github.com/rspec/rspec-rails'
  gem 'rspec-support', git: 'https://github.com/rspec/rspec-support'
  # Up to here

  gem 'capybara'
  gem 'factory_bot_rails'
end
