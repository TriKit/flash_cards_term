# CATEGORY
class Category
  attr_reader :card_list, :file_name

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
    @card_list.each do |card|      
      @card_list.delete(card) if card.front == front
    end
    @card_list
  end

  def write_to_file(file_name)
    File.open("./categories/#{file_name}.txt", 'w') do |f|
      @card_list.each { |t| f.puts(t.line_to_file) } if @card_list
    end
  end

  def show_cards
    if @card_list
      @card_list.each { |card| puts card.front }
    else
      puts 'There are no any cards yet'
    end
  end
end
