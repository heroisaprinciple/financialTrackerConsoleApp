# frozen_string_literal: true

require_relative "financialTrackerConsoleApp/version"
require_relative 'functioning'
require_relative 'authenticator'

module FinancialTrackerConsoleApp
  class Error < StandardError; end

  puts 'Hello, What would you like to choose? 1 - Register, 2 - Login, 3 - Exit'
  choice = gets.chomp

  exit if choice == '3'

  authenticator = Authenticator.new
  functioning = Functioning.new

  user_id = authenticator.action(choice)

  if user_id == -1
    exit
  end

  while 42
    puts 'Choose please: 1 - Add, 2 - Statistics, 3 - Clear'
    choice = gets.chomp

    functioning.action(choice, user_id)
  end
end
