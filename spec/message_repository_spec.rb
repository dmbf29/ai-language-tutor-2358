require "fileutils"

begin
  require_relative "../app/repositories/message_repository"
  require_relative "../app/models/message"
rescue LoadError => e
  if e.message =~ /message_repository/ || e.message =~ /message/
    describe "MessageRepository" do
      it "You need a `message_repository.rb` file for your `MessageRepository`" do
        fail
      end
    end
  else
    raise e
  end
end

describe "MessageRepository", :message do
  let(:csv_path) { "spec/support/messages.csv" }
  let(:repository) { MessageRepository.new(csv_path) }

  before(:each) { FileUtils.remove_file(csv_path, force: true) }
  after(:each) { FileUtils.remove_file(csv_path, force: true) }

  describe "#initialize" do
    it "should take one argument: the CSV file path where messages will eventually be stored" do
      expect { MessageRepository.new(csv_path) }.not_to raise_error
    end

    it "should not crash if the CSV path does not exist yet" do
      expect { MessageRepository.new("unexisting_file.csv") }.not_to raise_error
    end
  end

  describe "#create" do
    it "should add a message to the in-memory list" do
      repository.create(Message.new(role: "user", content: "How do you say cat?"))
      expect(repository.all.length).to eq(1)
    end
  end

  describe "#all" do
    it "should return all the messages stored by the repo, in order" do
      repository.create(Message.new(role: "user", content: "How do you say cat?"))
      repository.create(Message.new(role: "assistant", content: "Gato"))

      expect(repository.all.length).to eq(2)
      expect(repository.all[0].content).to eq("How do you say cat?")
      expect(repository.all[1].content).to eq("Gato")
    end

    it "should not expose the messages array through a reader" do
      expect(repository).not_to respond_to(:messages)
    end
  end
end
