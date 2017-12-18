source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Basic set
gem 'rails', '~> 5.1.4'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'therubyracer', '~> 0.12.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

# jQuery and bootstrap
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'bootstrap', '~> 4.0.0.beta2.1'
gem 'bootstrap-will_paginate', '~> 1.0.0'
gem 'will_paginate',           '~> 3.1.5'

# Twitter連携
gem 'omniauth'
gem 'omniauth-twitter'
gem 'twitter'

# メンテナンスモードを実装してくれるgem
gem 'turnout'

group :development, :test do
  # Use sqlite on dev mode
  gem 'sqlite3'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  # Use postgresql on production mode
  gem 'pg', '0.20.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
