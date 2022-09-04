require_relative 'repos/financialTrackerPurchaseRepo'

class Functioning
  def initialize
    @ftpr = FinancialTrackerConsoleApp::FinancialTrackerPurchaseRepo.new
  end

  def action(choice, user_id)
    if choice == '1'
      add(user_id)

    elsif choice == '2'
      statistics(user_id)

    elsif choice == '3'
      clear(user_id)

    end
  end

  def add(user_id)
    puts 'Choose category: '
    categories = @ftpr.get_categories

    puts '0 - Create a category'
    categories.values.each_with_index do |el, idx|
      puts "#{idx + 1} - #{el}"
    end

    choice = gets.chomp.to_i
    if choice == 0
      category_id = add_category
    else
      category_id = categories.keys[choice - 1]
    end

    puts 'Please, enter the name of a purchase: '
    name = gets.chomp

    puts 'Please, enter the price of a purchase: '
    price = gets.chomp

    puts 'Please, enter the date [dd-mm-yyyy] (which is optional): '
    date = gets.chomp

    begin
      @ftpr.add_entity(name, price, date, user_id, category_id)
      puts 'Thank you. A purchase is added...'
    rescue
      puts 'Nah, it is not added.'
    end

  end

  def add_category
    puts 'Enter category name: '
    name = gets.chomp

    @ftpr.add_category(name)
  end

  def statistics(user_id)
    puts 'Choose category: '
    categories = @ftpr.get_categories

    puts '0 - All categories'
    categories.values.each_with_index do |el, idx|
      puts "#{idx + 1} - #{el}"
    end

    choice = gets.chomp.to_i
    if choice == 0
      category_id = nil

    else
      category_id = categories.keys[choice - 1]
    end

    puts 'Please, select the period of time '
    puts '0 - All time'
    puts '1 - Day'
    puts '2 - Month'
    puts '3 - Year'
    choice = gets.chomp.to_i

    case choice
    when 0
      period = nil
    when 1
      period = 'day'
    when 2
      period = 'month'
    when 3
      period = 'year'

    else
      period = nil

    end

    purchases = @ftpr.get_purchases(user_id, category_id, period)
    if purchases.values.length == 0
      puts 'Purchases are not found.'

    else
      purchases.each do |el|
        puts "#{el['category_name']}: #{el['name']} = #{el['price']} (#{el['date'].to_s})"
      end
    end

  end

  def clear(user_id)
    puts 'Do you want to delete all your records? [Y/n]'
    choice = gets.chomp

    if choice.downcase == 'y'
      @ftpr.clear(user_id)
    end

  end

end
