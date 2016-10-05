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
      @card_list.each { |card| @removed = card if card.front == front }
      if !@removed.nil?
        @card_list.delete(@removed)
        show_message("Card #{front} removed") { |m| m.color(:green) }
      else
        show_message('There no such card') { |m| m.color(:red) }
      end
    else
      show_message('Category is empty') { |m| m.color(:red) }
    end
  end

  def write_to_file(file_name)
    File.open("./categories/#{file_name}", 'w') do |f|
      @card_list.each { |t| f.puts(t.line_to_file) } if @card_list
    end
  end

  def start(side)
    if @card_list
      tmp = @card_list.select { |card| card.point.to_i < 3 }
       until tmp.empty?
        tmp = tmp.select { |card| card.point.to_i < 3 }
        tmp.each_index do |index|
          side == 'front' ? show_front(tmp, index) : show_back(tmp, index)
          show_message('press ENTER to flip') { |m| m.color(:green) }
          input = STDIN.getc.chr
          if input == "\n"
            side == 'front' ? show_back(tmp, index) : show_front(tmp, index)
            show_message('set point by 1, 2 or 3') { |m| m.color(:green) }
            point = gets
            change_point(tmp, point, index)
          end
        end
      end
      show_message('All cards memorized') { |m| m.color(:green) }
    else
      show_message('Category is empty') { |m| m.color(:red) }
    end
  end

  def change_point(arr, point, index)
    arr[index].set_point(point)
    write_to_file(@file_name)
  end

  def show_front(arr, index)
    show_message(arr[index].front.upcase) { |m| m.color(:mintcream) }
  end

  def show_back(arr, index)
    show_message(arr[index].back) { |m| m.color(:mintcream) }
  end

  def show_front_and_back
    if @card_list
      @card_list.each { |card| show_message(card.front.upcase + ' - ' + card.back) { |m| m.color(:mintcream) } }
    else
      show_message('There are no any cards yet') { |m| m.color(:red) }
    end
  end

  def instruction
    puts '---------INSTRUCTION--------'.color(:yellow)
    puts 'All command arguments should be separated by comma'.color(:yellow)
    puts 'create, category'.color(:green) + ' - creates txt file for category'.color(:mintcream)
    puts 'delete, category'.color(:green) + ' - deletes category file'.color(:mintcream)
    puts 'open, category'.color(:green) + ' - change current cutegory'.color(:mintcream)
    puts 'all'.color(:green) + ' - shows front and back side of card in category'.color(:mintcream)
    puts 'start, side'.color(:green) + ' - starts memorize of card. Choose front or back side'.color(:mintcream)
    puts 'add, front, back'.color(:green) + ' - creates card'.color(:mintcream)
    puts 'remove, front'.color(:green) + ' - removes card'.color(:mintcream)
    puts 'exit'.color(:green) + ' - exit'.color(:mintcream)
    puts 'instruction'.color(:green) + ' - shows instruction'.color(:mintcream)
  end

  def show_categories
    puts '---------CATEGORIES---------'.color(:yellow)
    entries = Dir.entries('./categories')
    entries.delete('.')
    entries.delete('..')
    entries.delete('test.txt')
    entries.delete('default.txt')
    entries.each { |f| puts f.split('.')[0].upcase.color(:green) }
  end
end
