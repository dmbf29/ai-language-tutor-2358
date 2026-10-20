FakeChatResponse = Struct.new(:content)

# A fake stand-in for a RubyLLM chat object, so specs never call the real
# OpenAI API. It responds to the same methods our controllers use:
# `#with_instructions` (returns itself) and `#ask` (returns a canned reply).
class FakeChat
  def initialize(reply: "Gato")
    @reply = reply
  end

  def with_instructions(_prompt)
    self
  end

  def ask(_input)
    FakeChatResponse.new(@reply)
  end
end
