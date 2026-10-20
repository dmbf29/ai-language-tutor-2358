class LanguageRouter
  def initialize(languages_controller)
    @languages_controller = languages_controller
    @running = true
  end

  def run
    while @running
      display_actions
      action = gets.chomp.to_i
      route_action(action)
    end
  end

  private

  def route_action(action)
    case action
    when 1 then @languages_controller.list
    when 2 then @languages_controller.add
    when 3 then @languages_controller.delete
    when 4 then @languages_controller.learn
    when 0 then stop
    else
      puts "Please press 1, 2, 3 or 0"
    end
  end

  def stop
    @running = false
  end

  def display_actions
    puts ""
    puts "--------------------"
    puts "------- MENU -------"
    puts "--------------------"
    puts "1. List my languages"
    puts "2. Add a language"
    puts "3. Delete a language"
    puts "4. Learn a language"
    puts "0. Stop and exit"
    print "> "
  end
end
