class LanguageView
  def ask_for_name
    puts "What's the language?"
    gets.chomp
  end

  def ask_for_level
    puts "What's the level?"
    gets.chomp
  end

  def display_languages(languages)
    languages.each_with_index do |language, index|
      puts "#{index + 1}.) #{language.name}: #{language.level}"
    end
  end

  def ask_for_index
    puts "What number?"
    gets.chomp.to_i - 1
  end
end
