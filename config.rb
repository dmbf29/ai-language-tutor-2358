require "dotenv/load"
require "ruby_llm"

RubyLLM.configure do |config|
  if ENV.fetch("GITHUB_TOKEN", nil)
    config.openai_api_key = ENV.fetch("GITHUB_TOKEN", nil)
    config.openai_api_base = "https://models.inference.ai.azure.com"
  else
    config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
  end
end
