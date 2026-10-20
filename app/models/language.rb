class Language
  attr_accessor :id
  attr_reader :name, :level

  def initialize(attributes = {})
    @id = attributes[:id]
    @name = attributes[:name] # string
    @level = attributes[:level] # string
  end
end
