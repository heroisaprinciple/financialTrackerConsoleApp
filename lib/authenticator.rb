require_relative 'repos/financialTrackerUserRepo'

class Authenticator
  def initialize
    @ftur = FinancialTrackerConsoleApp::FinancialTrackerUserRepo.new
  end

  def action(choice)
    if choice == '1'
      register

    elsif choice == '2'
      login

    end
  end

  def register
    puts 'Your firstname:  '
    first_name = gets.chomp

    puts 'Your lastname: '
    last_name = gets.chomp

    puts 'Your email: '
    email = gets.chomp

    puts 'Your password: '
    password = gets.chomp

    res = @ftur.register(first_name, last_name, email, password)
    if res == -1
      puts 'Oh, no. A user can not be created...'
    end

    res
  end

  def login
    puts 'Please, enter your email: '
    email = gets.chomp

    puts 'Please, enter your password: '
    password = gets.chomp

    res = @ftur.login(email, password)
    if res == -1
      puts 'Oh, no. A user can not be authenticated...'
    end

    res

  end
end


