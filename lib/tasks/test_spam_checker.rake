# rubocop:disable Layout/LineLength
spam_bodies = [
  "Congratulations! You've just won a $1000 gift card! Click here to claim your prize: goo.gl/abcd1234",
  "Increase your website traffic and boost your sales with our proven SEO services! Visit www.exampleseo.com now!",
  "Hi, I love your blog! I also have a blog you might like, please visit and follow me at www.exampleblog.com",
  "Looking for a way to make money from home? Try this easy method and earn thousands per month! www.easymoney123.com",
  "Get the best deals on electronics, fashion, and more at www.examplestore.com - Hurry, limited time offer!",
  "I am a young Ukrainian, love to dance, new here. Wanna chat?",
  "Protect your computer and personal information with the ultimate antivirus software! Download now at www.antivirus123.com",
  "Unlock the secret to happiness and success with this life-changing book! Get your copy now at www.examplebook.com",
  "Need a loan? We offer instant approval and low interest rates! Apply now at www.fastcashloans.com",
  "Get thousands of real Instagram followers instantly! Visit www.insta-followers.com and boost your online presence today!"
]

offensive_bodies = [
  "I can't believe you wrote this garbage. You should be ashamed of yourself.",
  "I hope you get fired for writing such a stupid article.",
  "You're just a knob who doesn't know what they're talking about.",
  "This post is clearly biased and written by someone who hates immigrants.",
  "You're a terrible writer and your opinions are worthless.",
  "I can't believe you would write something so insensitive about vaccinations.",
  "Your post is offensive and could trigger someone who has experienced depression.",
  "Your language is offensive and perpetuates harmful stereotypes about indigenous polynesian tribes.",
  "Your post is tone-deaf and completely ignores the struggles of blind people.",
  "I'm disgusted that you would write something so ignorant and hurtful."
]

innocent_bodies = [
  "Good job team! Ship it!",
  "Great article! I found it very informative.",
  "I agree with your point of view. It's important to prioritize sustainability.",
  "I appreciate the time and effort you put into writing this post.",
  "This is an interesting topic. I'd love to learn more about it.",
  "Thanks for providing such valuable insights on this issue.",
  "I really enjoyed reading this. Keep up the good work!",
  "Your article inspired me to take action. Thank you for sharing your thoughts.",
  "I appreciate your honesty and transparency on this matter.",
  "This is a well-researched piece. It's clear you put a lot of thought into it."
]
# rubocop:enable Layout/LineLength

# Usage: rails spam_checker:test
namespace :spam_checker do
  desc "Test spam checker"
  task test: :environment do
    failed = false

    puts "Testing spam comments..."

    spam_comments =
      (spam_bodies + offensive_bodies).map do |body|
        Comment.new(body:, email: "john.doe@example.com", name: "John Doe")
      end

    spam_comments
      .map { |comment| SpamChecker.new(comment).spam? }
      .each_with_index do |is_spam, index|
        if is_spam
          failed = true
          puts "False negative: \"#{spam_comments[index].body}\""
        end
      end

    puts "Done testing spam comments."

    puts "Testing innocent comments..."

    innocent_comments =
      innocent_bodies.map do |body|
        Comment.new(body:, email: "john.doe@example.com", name: "John Doe")
      end

    innocent_comments
      .map { |comment| SpamChecker.new(comment).spam? }
      .each_with_index do |is_spam, index|
        if is_spam
          failed = true
          puts "False positive: \"#{innocent_comments[index].body}\""
        end
      end

    puts "Done testing innocent comments."

    if failed
      puts "Test failed"
    else
      puts "Test passed, all comments classified correctly"
    end
  end
end
