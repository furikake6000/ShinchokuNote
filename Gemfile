source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Basic set
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'listen', '~>3.1'
gem 'mini_magick', '~> 4.8'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.2.2'
gem 'sass-rails', '~> 5.0'
gem 'slim', '~> 3.0'
gem 'mini_racer', '~> 0.2.3'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

# jQuery and bootstrap
gem 'bootstrap', '~> 4.3.1'
gem 'bootstrap-will_paginate', '~> 1.0.0'
gem 'jquery-rails', '~>4.3.1'
gem 'jquery-ui-rails', '~>6.0.1'
gem 'will_paginate', '~> 3.1.5'

# Twitter連携
gem 'omniauth', '~>1.7'
gem 'omniauth-twitter', '~>1.4'
gem 'twitter', '~>6.2.0'

# メンテナンスモードを実装してくれるgem
gem 'turnout', '~>2.4'

# Security(Encryption)
gem 'rbnacl', '~>5.0'

# font-awesome
gem 'font-awesome-rails', '~>4.7'

# Enumのローカリゼーションをしてくれる
gem 'enum_help', '~>0.0'

# React.js
#gem 'react-rails', '~>2.4'

# 論理削除を実装するparanoia
gem 'paranoia', '~>2.4'

# newrelic rpm
gem 'newrelic_rpm'

# datetimepicker
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'

# webpush notification
gem 'serviceworker-rails'
gem 'webpush'

# Google Cloud Storage
gem 'google-cloud-storage', '~> 1.3', require: false

# cron
gem 'whenever', '~> 0.10.0', require: false

# schemaやrouteを書き出してくれるAnnotate
gem 'annotate', '~>2.7.4'

# Google reCAPTCHA
gem 'recaptcha', require: "recaptcha/rails"

# fixing security vulnerabilities
gem 'sprockets', '~> 3.7.2'
gem 'ffi', '~> 1.9.25'
gem "rack", ">= 2.0.6"
gem 'rubyzip', '~> 1.2.2'
gem 'loofah', '>= 2.2.3'

group :development, :test do
  gem 'byebug', '~>9.1', platforms: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver', '~>3.8'

  # Use sqlite on dev mode
  gem 'sqlite3', '~>1.3.13'

  # Relationship diagrams
  gem 'rails-erd', '~>1.5'
end

group :development do
  gem 'spring', '~>2.0'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '~>3.5'

  # code refactoring
  gem 'rubocop', '~>0.55'
  gem 'scss-lint', '~>0.7'
end

group :test do
  gem 'rails-controller-testing', '~>1.0'
end

group :production do
  # Use postgresql on production mode
  gem 'pg', '~>1.0.0'
end

# Below gem is only for Windows
# gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
