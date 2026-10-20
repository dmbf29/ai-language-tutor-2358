require 'csv'
require_relative '../models/message'

class MessageRepository
  def initialize(csv_file_path, language_repository)
    @csv_file_path = csv_file_path
    @language_repository = language_repository
    @messages = []
    @next_id = 1
    load_csv
  end

  def create(message)
    message.id = @next_id
    @next_id += 1
    @messages << message
    save_csv
  end

  def all
    @messages
  end

  def all_for(language)
    @messages.select do |message|
      message.language == language
    end
  end

  private

  def load_csv
    return unless File.exist?(@csv_file_path)

    CSV.foreach(@csv_file_path, headers: :first_row, header_converters: :symbol) do |row|
      # convert any non-string attributes back into the original form
      row[:id] = row[:id].to_i
      # take language_id as a string and get a language from the repository
      row[:language] = @language_repository.find(row[:language_id].to_i)
      message = Message.new(row)
      @messages << message
      @next_id = message.id + 1
    end
  end

  def save_csv
    CSV.open(@csv_file_path, 'wb') do |csv|
      csv << %w[id role content language_id]
      @messages.each do |message|
        csv << [message.id, message.role, message.content, message.language&.id]
      end
    end
  end
end
