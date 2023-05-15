ActiveJob::Base.queue_adapter = :sidekiq unless Rails.env.test?
