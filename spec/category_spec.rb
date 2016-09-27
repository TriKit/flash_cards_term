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

  describe 'show_card_front' do
    it 'shows cards front if card_list is not empty' do
      category = Category.new('test3.txt')
      card = Card.new('java', 'object oriented programming language')
      expect($stdout).to receive(:puts).with('java')
      @category.delete_category('test3.txt')
    end

    it 'shows message if category is empty' do
      category = Category.new('test4.txt')
      expect($stdout).to receive(:puts).with('There are no any cards yet')
      @category.delete_category('test4.txt')
    end
  end

  describe 'remove_card' do
    it 'puts message if category is empty' do
      category = Category.new('test2.txt')
      category.remove_card('html')
      expect($stdout).to receive(:puts).with('Category is empty')
      @category.delete_category('test2.txt')
    end

    it 'puts message if card not exist' do
      @category.remove_card('html')
      expect($stdout).to receive(:puts).with('There no such card')
    end

    it 'removes card from category if card exist' do
      card = Card.new('html', 'the standard markup language for creating web pages and web applications')
      @category.add_card(card)
      @category.remove_card('html')
      expect(@category.card_list).not_to include(card)
    end
  end

  describe 'check category name' do
    it 'returns true if category exists' do
      expect(@category.check_category_name('test')).to be_truthy
    end

    it 'returns false if category not exists' do
      expect(@category.check_category_name('unbelivable')).to be_falsy
    end
  end

  it 'writes changes to category file' do
    card = Card.new('html', 'the standard markup language for creating web pages and web applications')
    @category.add_card(card)
    @category.write_to_file('test.txt')
    @category.remove_card('html')
    @category.write_to_file('test.txt')
  end
end
