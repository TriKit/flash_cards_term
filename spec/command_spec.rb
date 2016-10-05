require 'spec_helper'
require_relative '../command'
require_relative '../category'
require_relative '../card'

RSpec.describe Command do
  before(:each) do
    suppress_log_output
    @category = Category.new('test.txt')
    @category.read_file
  end

  it 'puts message if command is invalid' do
    command = Command.new(@category, 'invalid command, command_test')
    command.execute
    expect(@@last_message).to eq('Invalid command. Please try again')
  end

  it 'creates category file' do
    command = Command.new(@category, 'create_category, test_category')
    command.execute
    expect(Dir.entries('categories').include?('test_category.txt')).to be_truthy
  end

  describe 'delete' do
    it 'deletes category file' do
      command = Command.new(@category, 'delete_category, test_category')
      command.execute
      expect(Dir.entries('categories').include?('test_category.txt')).to be_falsy
      expect(@@last_message).to eq('Category test_category deleted')
    end

    it 'shows message if category does not exist' do
      command = Command.new(@category, 'delete_category, invalid_category')
      command.execute
      expect(@@last_message).to eq('There no such category')
    end
  end

  describe 'open' do
    it 'shows message if category does not exist' do
      command = Command.new(@category, 'open, invalid_category')
      command.execute
      expect(@@last_message).to eq('There no such category')
    end
  end

  describe 'front' do
    it 'shows message if current category is default' do
      category = Category.new('default.txt')
      command = Command.new(category, 'front')
      command.execute
      expect(@@last_message).to eq('You should open category file')
    end
  end

  describe 'back' do
    it 'shows message if current category is default' do
      category = Category.new('default.txt')
      command = Command.new(category, 'back')
      command.execute
      expect(@@last_message).to eq('You should open category file')
    end
  end

  describe 'all' do
    it 'shows message if current category is default' do
      category = Category.new('default.txt')
      command = Command.new(category, 'all')
      command.execute
      expect(@@last_message).to eq('You should open category file')
    end
  end

  it 'creates card to category' do
    command = Command.new(@category, 'create_card, front, back')
    command.execute
    @category.read_file
    expect(@category.card_list.last.front).to eq('front')
    expect(@@last_message).to eq('Card front added')
  end

  it 'deletes card from category' do
    command = Command.new(@category, 'delete_card, front')
    command.execute
    @category.read_file
    expect(@category.card_list.last.front).to eq('java')
  end
end
