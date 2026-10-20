class MessageView
  def display_list(messages)
    puts "No messages yet. Start the conversation by sending a message!" if messages.empty?

    messages.each do |message|
      prefix = message.role == "user" ? "You" : "Tutor"
      puts "#{prefix}: #{message.content}"
    end
  end

  def ask_for_content
    puts ""
    puts "Your message?"
    print "> "
    gets.chomp
  end

  def display_one(message)
    puts ""
    puts "Tutor: #{message.content}"
  end
end
