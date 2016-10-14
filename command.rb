require 'rainbow/ext/string'
require_relative './category'

# COMMAND
class Command
  attr_accessor :category, :command_name

  def initialize(category, command_string)
    @category = category
    command_string.rstrip!
    command_arr = command_string.split(',')
    @name = command_arr.shift
    @args = command_arr
    @args = command_arr.map do |i|
      i[0] = '' if i[0] == ' '
      i
    end
  end

  def execute
    begin
      send(@name, *@args)
    rescue NoMethodError => e
      e.to_s.include?('for #<Command') ? show_message('Invalid command. Please try again') { |m| m.color(:red) } : raise e
    rescue ArgumentError => e
      # raise e
      show_message('Wrong number of arguments. Try again') { |m| m.color(:red) }
    end
  end

  private

  def instruction
    @category.instruction
  end

  # CATEGORY
  def create(*args)
    if args[0] == 'category'
      create_category(args[1])
    elsif args[0] == 'card'
      create_card(*args[1..args.length-1])
    end
  end

  def create_category(category)
    @category = Category.new("#{category}.txt")
    @category.read_file
  end

  def delete_category(category)
    if Dir.entries('categories').include?("#{category}.txt")
      @category.delete_category(category)
      show_message("Category #{category} deleted") { |m| m.color(:green) }
      @category.show_categories
    else
      show_message('There no such category') { |m| m.color(:red) }
    end
  end

  def all
    if @category.file_name == 'default.txt'
      show_message('You should open category file') { |m| m.color(:red) }
    else
      @category.show_front_and_back
    end
  end

  def open(category)
    if Dir.entries('categories').include?("#{category}.txt")
      create_category(category)
      show_message("Current category is #{category.upcase}") { |m| m.color(:green) }
    else
      show_message('There no such category') { |m| m.color(:red) }
    end
  end

  def start(side='front')
    if side == 'front' || side == 'back'
      @category.start(side)
    else
      show_message('side should be front or back') { |m| m.color(:red) }
    end
  end

  def reset
    @category.reset
    show_message('Reset cards points to zero') { |m| m.color(:green) }
  end

  # CARD
  def create_card(front, back)
    card = Card.new(front, back)
    @category.add_card(card)
    @category.write_to_file(@category.file_name)
    show_message("Card #{front} added") { |m| m.color(:green) }
  end

  def delete_card(card_front)
    @category.remove_card(card_front)
    @category.write_to_file(@category.file_name)
  end

  # GLOBAL
  def exit
    Kernel.exit
  end
  alias quit exit
end
