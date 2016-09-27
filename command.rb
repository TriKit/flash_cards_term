require 'rainbow/ext/string'

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
  end

  def check_category_name(category)
    Dir.entries('categories').include?("#{category}.txt")
  end

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
    if @category.check_category_name(category)
      @category.delete_category(category)
      puts 'Category ' + category.to_s.upcase.color(:mintcream) + ' deleted'
      @category.show_categories
    else
      puts 'There no such category'.color(:red)
    end
  end

  # show front side of category cards
  def show(category)
    if check_category_name(category)
      create(category)
      @category.show_cards_front
    else
      puts 'There no such category'.color(:red)
    end
  end

  # CARD
  # add new card to category
  def add(front, back, category)
    card = Card.new(front, back)
    create(category)
    @category.add_card(card)
    @category.write_to_file("#{category}.txt")
    puts @category.card_list.last.print_card
  end

  def remove(card_front, category)
    if check_category_name(category)
      create(category)
      @category.remove_card(card_front)
      @category.write_to_file("#{category}.txt")
    else
      puts 'There no such category'.color(:red)
    end
  end

  # GLOBAL
  def exit
    Kernel.exit
  end
  alias quit exit
end
