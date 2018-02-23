source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Basic set
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.4'
gem 'sass-rails', '~> 5.0'
gem 'therubyracer', '~> 0.12.3'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

# jQuery and bootstrap
gem 'bootstrap', '~> 4.0.0.beta2.1'
gem 'bootstrap-will_paginate', '~> 1.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'will_paginate', '~> 3.1.5'

# Twitter連携
gem 'omniauth'
gem 'omniauth-twitter'
gem 'twitter'

# メンテナンスモードを実装してくれるgem
gem 'turnout'

# code refactoring
gem 'rubocop'
gem 'scss-lint'

# Security(Encryption)
gem 'sodium'

group :development, :test do
  # Use sqlite on dev mode
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'sqlite3'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'rails-controller-testing'
end

group :production do
  # Use postgresql on production mode
  gem 'pg', '0.20.0'
end

# Below gem is only for Windows
# gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
