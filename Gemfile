source 'https://rubygems.org'

# Same Ruby version as my IDE. Should reduce hiccups.
ruby "2.2.1"
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use SCSS for stylesheets
# gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt'

# For emails
gem 'postmark'
# Trying to do Google Searches
gem 'google-search'

# Allowing me to render Markdown written blogs into HTML.
# Followed https://www.codefellows.org/blog/how-to-create-a-markdown-friendly-blog-in-a-rails-app
# in order to get here.
gem 'redcarpet'
gem 'coderay'

# Daily Messenger Gems
## My own gem for date parsing.
gem 'date_parser'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# ____________________________________________
# Gems I'm not that familiar with yet:

# Decided to use SASS out of a preference for nesting.
gem 'bootstrap-sass', '~> 3.2.0'
# Autoprefixer automatically adds proper vendor prefixes when CSS is compiled.
gem 'autoprefixer-rails'

group :development, :test do
  # Use sqlite3 as the database for Active Record
gem 'sqlite3'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# Needed for Heroku deployment.
group :production do
  gem 'pg',             '0.17.1'
  gem 'rails_12factor', '0.0.2'
end
