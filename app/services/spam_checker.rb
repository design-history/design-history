class SpamChecker
  def initialize(comment)
    @comment = comment
  end

  def spam?
    prompt = <<~PROMPT
      Email: #{@comment.email}
      Name: #{@comment.name}
      Body: #{@comment.body}

      ---

      Is this comment spam, hateful, or offensive? (1 = yes, 0 = no)
    PROMPT

    result =
      client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [{ role: "user", content: prompt }],
          max_tokens: 1, # Reply with a single character, saves quota
          temperature: 0, # Makes reply deterministic, same input = same output
          top_p: 1, # Also reduces randomness
          n: 1, # Return only one choice
          stream: false, # Don't stream response in
          stop: ["\n"]
        }
      )

    result.dig("choices", 0, "message", "content") == "1"
  end

  private

  def client
    @client ||= OpenAI::Client.new
  end
end
