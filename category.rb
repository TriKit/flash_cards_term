require 'rainbow/ext/string'

# CATEGORY
class Category
  attr_accessor :card_list, :file_name

  def initialize(file_name)
    @file_name = file_name
    create_category_file
  end

  def create_category_file
    File.new("./categories/#{@file_name}", 'w') unless File.exist?("./categories/#{@file_name}")
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

  def flip
    flip_method = @side == 'front' ? 'back' : 'front'
    @card_list[@current_card_index].send("show_#{flip_method}")
  end

  def opposite_side(side)
    if side == 'front'
      'back'
    else
      'front'
    end
  end

  def start(side)
    @side = side
    if @card_list
      tmp = @card_list.select { |card| card.point.to_i < 3 }
      until tmp.empty?
        tmp = tmp.select { |card| card.point.to_i < 3 }
        tmp.each_index do |i|
          tmp[i].send("show_#{@side}")
          show_message('press ENTER to flip') { |m| m.color(:orange) }
          input = STDIN.getc.chr
          if input == "\n"
            tmp[i].send("show_#{opposite_side(side)}")
            show_message('set point by 1, 2 or 3') { |m| m.color(:orange) }
            point = gets.chomp
            point(tmp, i, point)
          end
        end
      end
      show_message('Congratulations') { |m| m.color(:green) }
    else
      show_message('There are no any cards yet') { |m| m.color(:red) }
    end
  end

  def point(array, index, point)
    array[index].change_point(point)
    write_to_file(@file_name)
  end

  def show_front_and_back
    if @card_list
      @card_list.each { |card| show_message(card.front.upcase + ' - ' + card.back) { |m| m.color(:mintcream) } }
    else
      show_message('There are no any cards yet') { |m| m.color(:red) }
    end
  end

  def reset
    @card_list.map do |card|
      card.point = 0
    end
    write_to_file(@file_name)
  end

  def instruction
    puts '---------INSTRUCTION--------'.color(:yellow)
    puts 'All command arguments should be separated by comma'.color(:yellow)
    puts 'create, category or card(front, back)'.color(:green) + ' - creates txt file for category or card'.color(:mintcream)
    puts 'delete_category, category'.color(:green) + ' - deletes category file'.color(:mintcream)
    puts 'open, category'.color(:green) + ' - change current cutegory'.color(:mintcream)
    puts 'all'.color(:green) + ' - shows front and back side of card in category'.color(:mintcream)
    puts 'start, side'.color(:green) + ' - starts showing cards. Side is optional. Default side is front'.color(:mintcream)
    puts 'delete_card, front'.color(:green) + ' - removes card'.color(:mintcream)
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
