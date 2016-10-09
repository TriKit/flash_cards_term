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

  it 'resets point to 0 in all category cards' do
    command = Command.new(@category, 'open, test')
    command.execute
    command2 = Command.new(@category, 'reset')
    command2.execute
    expect(@category.card_list.last.point).to eq(0)
    expect(@@last_message).to eq('Reset cards points to zero')
  end

  it 'sets point to card' do
    command = Command.new(@category, 'open, test')
    command.execute
    command2 = Command.new(@category, 'side, front')
    command2.execute
    command3 = Command.new(@category, 'next')
    command3.execute
    command4 = Command.new(@category, 'point, 1')
    command4.execute
    expect(@category.card_list.last.point).to eq(1)
  end

  it 'shows back side of card' do
    command = Command.new(@category, 'open, test')
    command.execute
    command2 = Command.new(@category, 'side, front')
    command2.execute
    command3 = Command.new(@category, 'next')
    command3.execute
    command4 = Command.new(@category, 'flip')
    command4.execute
    expect(@@last_message).to eq('object oriented programming language')
  end
end
