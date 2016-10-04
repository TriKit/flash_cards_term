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
    commands = %w(create_category open delete_category create_card delete_card exit instruction front back all)
    if commands.include?(@name)
      send(@name, *@args)
    else
      show_message('Invalid command. Please try again') { |m| m.color(:red) }
    end
  end

  private

  def instruction
    @category.instruction
  end

  # CATEGORY
  # create new category
  def create_category(category)
    @category = Category.new("#{category}.txt")
    @category.read_file
  end

  # delete category
  def delete_category(category)
    if Dir.entries('categories').include?("#{category}.txt")
      @category.delete_category(category)
      show_message("Category #{category} deleted") { |m| m.color(:green) }
      @category.show_categories
    else
      show_message('There no such category') { |m| m.color(:red) }
    end
  end

  # show front side of category cards
  def front
    if @category.file_name == 'default.txt'
      show_message('You should open category file') { |m| m.color(:red) }
    else
      @category.show_front
    end
  end

  # show back side of category cards
  def back
    if @category.file_name == 'default.txt'
      show_message('You should open category file') { |m| m.color(:red) }
    else
      @category.show_back
    end
  end

  # show front and back side of category cards
  def all
    if @category.file_name == 'default.txt'
      show_message('You should open category file') { |m| m.color(:red) }
    else
      @category.show_front_and_back
    end
  end

  def open(category)
    if Dir.entries('categories').include?("#{category}.txt")
      create(category)
      show_message("Current category is #{category}") { |m| m.color(:green) }
    else
      show_message('There no such category') { |m| m.color(:red) }
    end
  end

  # CARD
  # add new card to category
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

  def set_point(card, point)
    @category.card_list.each do |c|
      if c.front == card
        c.set_point(point)
        @category.write_to_file(@category.file_name)
      end
    end
  end

  # GLOBAL
  def exit
    Kernel.exit
  end
  alias quit exit
end
