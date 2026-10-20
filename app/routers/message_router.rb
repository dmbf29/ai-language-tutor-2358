class MessageRouter
  def initialize(controller)
    @controller = controller
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
    when 1 then @controller.list
    when 2 then @controller.add
    when 3 then stop
    else
      puts "Please press 1, 2 or 3"
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
    puts "1. List my conversation"
    puts "2. Send a message"
    puts "3. Stop and exit"
    print "> "
  end
end
