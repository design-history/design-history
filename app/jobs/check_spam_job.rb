class CheckSpamJob < ApplicationJob
  queue_as :default

  def perform(comment)
    comment.update(spam: SpamChecker.new(comment).spam?)
  end
end
