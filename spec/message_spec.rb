begin
  require_relative "../app/models/message"
rescue LoadError => e
  if e.message =~ /message/
    describe "Message" do
      it "You need a `message.rb` file for your `Message` model" do
        fail
      end
    end
  else
    raise e
  end
end

describe "Message", :message do
  it "should be initialized with an id, a role and content" do
    message = Message.new(id: 1, role: "user", content: "How do you say cat?")
    expect(message).to be_a(Message)
  end

  describe "#id" do
    it "should return the id of the message" do
      message = Message.new(id: 1, role: "user", content: "How do you say cat?")
      expect(message.id).to eq(1)
    end
  end

  describe "#role" do
    it "should return the role of the message" do
      message = Message.new(id: 1, role: "user", content: "How do you say cat?")
      expect(message.role).to eq("user")
    end
  end

  describe "#content" do
    it "should return the content of the message" do
      message = Message.new(id: 1, role: "user", content: "How do you say cat?")
      expect(message.content).to eq("How do you say cat?")
    end
  end
end
