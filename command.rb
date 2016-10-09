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
      if e.to_s.include?('for #<Command')
        show_message('Invalid command. Please try again') { |m| m.color(:red) }
      else
        raise e
      end
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

  # show front and back side of category cards
  def all
    if @category.file_name == 'default.txt'
      show_message('You should open category file') { |m| m.color(:red) }
    else
      @category.show_front_and_back
    end
  end

  # open category file
  def open(category)
    if Dir.entries('categories').include?("#{category}.txt")
      create_category(category)
      show_message("Current category is #{category.upcase}") { |m| m.color(:green) }
    else
      show_message('There no such category') { |m| m.color(:red) }
    end
  end

  def next
    @category.next
  end

  def side(side)
    @category.set_side(side)
  end

  def flip
    @category.flip
  end

  def point(point)
    @category.set_point(point)
  end

  # reset cards point to zero in category
  def reset
    @category.reset
    show_message('Reset cards points to zero') { |m| m.color(:green) }
  end

  # CARD
  # add new card to category
  def create_card(front, back)
    card = Card.new(front, back)
    @category.add_card(card)
    @category.write_to_file(@category.file_name)
    show_message("Card #{front} added") { |m| m.color(:green) }
  end

  # delete card by input car front
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
