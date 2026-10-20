class Message
  attr_accessor :id
  attr_reader :role, :content, :language

  def initialize(attributes = {})
    @id = attributes[:id] # integer
    @role = attributes[:role] # string
    @content = attributes[:content] # string
    @language = attributes[:language] # INSTANCE of a language
  end
end
