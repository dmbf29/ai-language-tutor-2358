require "fileutils"
require "ruby_llm"
require_relative "support/fake_chat"

begin
  require_relative "../app/controllers/messages_controller"
  require_relative "../app/repositories/message_repository"
rescue LoadError => e
  if e.message =~ /message_repository/ || e.message =~ /messages_controller/
    describe "MessagesController" do
      it "You need a `messages_controller.rb` file for your `MessagesController`" do
        fail
      end
    end
  else
    raise e
  end
end

describe "MessagesController", :message do
  let(:csv_path) { "spec/support/messages.csv" }
  let(:repository) { MessageRepository.new(csv_path) }
  let(:controller) { MessagesController.new(repository) }

  before(:each) do
    FileUtils.remove_file(csv_path, force: true)
    allow(RubyLLM).to receive(:chat).and_return(FakeChat.new(reply: "Gato"))
  end

  after(:each) { FileUtils.remove_file(csv_path, force: true) }

  it "should be initialized with a repository" do
    expect(controller).to be_a(MessagesController)
  end

  describe "#add" do
    it "should ask the user for a message, store it, then ask the chat client and store its reply" do
      allow_any_instance_of(Object).to receive(:gets).and_return("How do you say cat?")

      controller.add

      expect(repository.all.length).to eq(2)
      expect(repository.all[0].role).to eq("user")
      expect(repository.all[0].content).to eq("How do you say cat?")
      expect(repository.all[1].role).to eq("assistant")
      expect(repository.all[1].content).to eq("Gato")
    end
  end

  describe "#list" do
    it "should grab messages from the repo and display them" do
      allow_any_instance_of(Object).to receive(:gets).and_return("How do you say cat?", "How do you say dog?")
      controller.add
      controller.add

      expect(STDOUT).to receive(:puts).with(/How do you say cat\?/)
      expect(STDOUT).to receive(:puts).with(/How do you say dog\?/)
      expect(STDOUT).to receive(:puts).with(/Gato/).twice

      controller.list
    end
  end
end
