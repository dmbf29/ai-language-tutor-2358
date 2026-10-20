require_relative "config"
require_relative "app/repositories/message_repository"
require_relative "app/controllers/messages_controller"
require_relative "app/repositories/language_repository"
require_relative "app/controllers/languages_controller"
require_relative "app/routers/message_router"
require_relative "app/routers/language_router"

language_repository = LanguageRepository.new("data/languages.csv")
message_repository = MessageRepository.new("data/messages.csv", language_repository)

languages_controller = LanguagesController.new(language_repository, message_repository)

LanguageRouter.new(languages_controller).run
