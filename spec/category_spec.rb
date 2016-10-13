require 'spec_helper'
require_relative '../category'
require_relative '../card'

RSpec.describe Category do
  before(:each) do
    suppress_log_output
    @card = Card.new('java', 'object oriented programming language')
    @category = Category.new('test.txt')
    @category.add_card(@card)
  end

  it 'reads category file' do
    @category.read_file
    expect(@category.card_list[0].front).to eq('java')
    expect(@category.card_list[0].point).to eq(0)
  end

  it 'adds card to category' do
    card = Card.new('html', 'the standard markup language for creating web pages and web applications')
    @category.add_card(card)
    expect(@category.card_list).to include(card)
  end

  describe 'show_front_and_back' do
    it 'shows cards front and back if card_list is not empty' do
      @category.show_front_and_back
      expect(@@last_message).to eq('JAVA - object oriented programming language')
    end

    it 'shows message if category is empty' do
      category = Category.new('test2.txt')
      category.show_front_and_back
      expect(@@last_message).to eq('There are no any cards yet')
      @category.delete_category('test2')
    end
  end

  describe 'remove_card' do
    it 'shows message if category is empty' do
      category = Category.new('test2.txt')
      category.remove_card('html')
      expect(@@last_message).to eq('Category is empty')
      @category.delete_category('test2')
    end

    it 'shows message if card not exist' do
      @category.remove_card('html')
      expect(@@last_message).to eq('There no such card')
    end

    it 'removes card from category if card exist' do
      card = Card.new('html', 'the standard markup language for creating web pages and web applications')
      @category.add_card(card)
      @category.remove_card('html')
      expect(@category.card_list).not_to include(card)
    end
  end

  it 'writes changes to category file' do
    card = Card.new('html', 'the standard markup language for creating web pages and web applications')
    @category.add_card(card)
    @category.write_to_file('test.txt')
    @category.remove_card('html')
    @category.write_to_file('test.txt')
  end

  it 'resets cards point to zero' do
    @category.card_list[0].set_point(1)
    @category.reset
    expect(@category.card_list.last.point).to eq(0)
  end

  it 'sets side' do
    expect(@category.set_side('back')).to eq('back')
  end

  it 'sets point to card' do
    @category.card_list[0].set_point(1)
    expect(@category.card_list[0].point).to eq(1)
  end

  describe 'flip' do
    it 'shows back side if @side equal front' do

    end

    it 'shows front side if @side equal back' do
      
    end
  end
end
