class LanguageRepository
  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @languages = []
    @next_id = 1
    load_csv
  end

  def create(language)
    language.id = @next_id
    @next_id += 1
    @languages << language
    save_csv
  end

  def all
    @languages
  end

  def find(id)
    @languages.find do |language|
      language.id == id
    end
  end

  def destroy(index)
    @languages.delete_at(index)
  end

  private

  def save_csv
    CSV.open(@csv_file_path, 'wb') do |csv|
      csv << %w[id level name]
      @languages.each do |language|
        csv << [language.id, language.level, language.name]
      end
    end
  end

  def load_csv
    return unless File.exist?(@csv_file_path)

    CSV.foreach(@csv_file_path, headers: :first_row, header_converters: :symbol) do |row|
      # convert any non-strings before we create the instance
      row[:id] = row[:id].to_i
      language = Language.new(row)
      @languages << language
      @next_id = language.id + 1
    end
  end
end
