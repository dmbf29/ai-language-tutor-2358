require_relative '../models/language'
require_relative '../views/language_view'

class LanguagesController
  def initialize(language_repository, message_repository)
    @language_repository = language_repository
    @message_repository = message_repository
    @language_view = LanguageView.new
  end

  def add
    # tell the view to ask for language name
    name = @language_view.ask_for_name
    # tell the view to ask for language level
    level = @language_view.ask_for_level
    # create an instance a language
    language = Language.new(name: name, level: level)
    # give that language instance to the repository
    @language_repository.create(language)
  end

  def list
    # get all the languages from the repository
    languages = @language_repository.all
    # give the languages to the view to display
    @language_view.display_languages(languages)
  end

  def learn
    # get all the languages from the repository
    languages = @language_repository.all
    # give the languages to the view to display
    @language_view.display_languages(languages)
    # have the view ask the user to choose
    index = @language_view.ask_for_index
    language = languages[index]

    messages_controller = MessagesController.new(@message_repository, language)
    MessageRouter.new(messages_controller).run
  end
end
