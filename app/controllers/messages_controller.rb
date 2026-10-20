require_relative '../views/message_view'

class MessagesController
  def initialize(message_repository, language)
    @message_repository = message_repository
    @language = language
    @view = MessageView.new
    @chat = RubyLLM.chat.with_instructions(system_prompt)
  end

  def list
    messages = @message_repository.all_for(@language)
    @view.display_list(messages)
  end

  def add
    content = @view.ask_for_content
    user_message = Message.new(role: "user", content: content, language: @language)
    @message_repository.create(user_message)

    response = @chat.ask(content)
    assistant_message = Message.new(
      role: "assistant",
      content: response.content,
      language: @language
    )
    @message_repository.create(assistant_message)

    @view.display_one(assistant_message)
  end

  private

  def system_prompt
    "You are a friendly, patient #{@language.name} tutor. The user wants to practice #{@language.name} " \
      "at an #{@language.level} level. When they ask how to say something, answer primarily in " \
      "#{@language.name} and add a short English translation in parentheses. Keep your answers " \
      "short and encouraging."
  end
end
