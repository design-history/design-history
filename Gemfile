source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "avo"
gem "aws-sdk-s3", require: false
gem "bootsnap", require: false
gem "cssbundling-rails"
gem "data_migrate", "9.1.0"
gem "devise"
gem "friendly_id"
gem "good_job"
gem "govuk-components"
gem "govuk_design_system_formbuilder"
gem "govuk_markdown"
gem "hotwire-livereload"
gem "image_processing"
gem "jsbundling-rails"
gem "pg", "~> 1.5"
gem "propshaft"
gem "puma", "~> 6.3"
gem "rails", "~> 7.0.6"
gem "ruby-openai"
gem "sentry-rails"
gem "sentry-ruby"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails"
  gem "factory_bot_rails"
end

group :development do
  gem "annotate", require: false
  gem "prettier_print", require: false
  gem "rladr"
  gem "rubocop-govuk", require: false
  gem "solargraph", require: false
  gem "solargraph-rails", require: false
  gem "syntax_tree", require: false
  gem "syntax_tree-haml", require: false
  gem "syntax_tree-rbs", require: false
  gem "web-console"
end

group :test do
  gem "cuprite"
  gem "faker"
  gem "rspec"
  gem "rspec-rails"
end
