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
    send(@name, *@args)
    #check_command
  end

  # def check_category_name(category)
  #   Dir.entries('categories').include?("#{category}.txt")
  # end

  private

  def instruction
    @category.instruction
  end

  # CATEGORY
  # create new category
  def create(category)
    @category = Category.new("#{category}.txt")
    @category.read_file
  end

  # delete category
  def delete(category)
    if Dir.entries('categories').include?("#{category}.txt")
      @category.delete_category(category)
      puts 'Category ' + category.to_s.upcase.color(:mintcream) + ' deleted'
      @category.show_categories
    else
      puts 'There no such category'.color(:red)
    end
  end

  # show front side of category cards
  def front(category)
    if Dir.entries('categories').include?("#{category}.txt")
      create(category)
      @category.show_front
    else
      puts 'There no such category'.color(:red)
    end
  end

  # show front and back side of category cards
  def cards(category)
    if Dir.entries('categories').include?("#{category}.txt")
      create(category)
      @category.show_front_and_back
    else
      puts 'There no such category'.color(:red)
    end
  end

  # CARD
  # add new card to category
  def add(front, back)
    card = Card.new(front, back)
    @category.add_card(card)
    @category.write_to_file(@category.file_name)
    puts @category.card_list.last.print_card
  end

  def remove(card_front, category)
    if Dir.entries('categories').include?("#{category}.txt")
      create(category)
      @category.remove_card(card_front)
      @category.write_to_file("#{category}.txt")
    else
      puts 'There no such category'.color(:red)
    end
  end

  def set_point(card, point, category)
    create(category)
    @category.card_list.each do |c|
      if c.front == card
        c.set_point(point)
        @category.write_to_file("#{category}.txt")
      end
    end
  end

  # GLOBAL
  def exit
    Kernel.exit
  end
  alias quit exit
end
