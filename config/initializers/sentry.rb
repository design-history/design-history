Sentry.init do |config|
  config.dsn =
    "https://22aaba92b81046c098f8c2aa5b01e836@o4504255432425472.ingest.sentry.io/4504255433539584"
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda { |_context| true }
end
