require 'rainbow/ext/string'

# CATEGORY
class Category
  attr_accessor :card_list, :file_name

  def initialize(file_name)
    @file_name = file_name
    create_category_file
  end

  def create_category_file
    unless File.exist?("./categories/#{@file_name}")
      File.new("./categories/#{@file_name}", 'w')
    end
  end

  def delete_category(file_name)
    File.delete("./categories/#{file_name}.txt")
  end

  def read_file
    cards = File.readlines("./categories/#{@file_name}")
    cards.each do |line|
      tmp = line.split(/,\s*/)
      front = tmp[0]
      back  = tmp[1]
      point = tmp[2].rstrip
      add_card(Card.new(front, back, point))
    end
  end

  def add_card(card)
    @card_list ||= []
    @card_list << card
  end

  def remove_card(front)
    if @card_list
      @card_list.each do |card|
        if card.front == front
          @card_list.delete(card)
          puts 'Card ' + front.to_s.upcase.color(:mintcream) + ' removed'
        else
          show_message('There no such card') { |m| m.color(:red) }
        end
      end
      @card_list
    else
      show_message('Category is empty') { |m| m.color(:red) }
    end
  end

  def write_to_file(file_name)
    File.open("./categories/#{file_name}", 'w') do |f|
      @card_list.each { |t| f.puts(t.line_to_file) } if @card_list
    end
  end

  def show_front
    p @cards_list
    if @card_list
      @card_list.each { |card| puts card.front }
    else
      show_message('There are no any cards yet') { |m| m.color(:red) }
    end
  end

  def show_back
    if @card_list
      @card_list.each { |card| puts card.back }
    else
      puts 'There are no any cards yet'
    end
  end

  def show_front_and_back
    if @card_list
      @card_list.each { |card| puts card.front.upcase.color(:mintcream) + ' ' + card.back }
    else
      puts 'There are no any cards yet'
    end
  end

  def instruction
    puts '---------INSTRUCTION--------'.color(:orange)
    puts 'All command arguments should be separated by comma'.color(:orange)
    puts 'create, category'.color(:blue) + ' - creates txt file for category'.color(:yellow)
    puts 'delete, category'.color(:blue) + ' - deletes category file'.color(:yellow)
    puts 'all, category'.color(:blue) + ' - shows front and back side of card in category'.color(:yellow)
    puts 'front, category'.color(:blue) + ' - shows front side of card in category'.color(:yellow)
    puts 'add, front, back, category'.color(:blue) + ' - creates card'.color(:yellow)
    puts 'remove, card, category'.color(:blue) + ' - removes card'.color(:yellow)
    puts 'exit'.color(:blue) + ' - exit'.color(:yellow)
    puts 'instruction'.color(:blue) + ' - shows instruction'.color(:yellow)
  end

  def show_categories
    puts '---------CATEGORIES---------'.color(:orange)
    entries = Dir.entries('./categories')
    entries.delete('.')
    entries.delete('..')
    entries.delete('test.txt')
    entries.delete('default.txt')
    entries.each { |f| puts f.split('.')[0].upcase.color(:green) }
  end
end
