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

  it 'creates category file' do
    command = Command.new(@category, 'create, command_test')
    command.execute
    expect(Dir.entries('categories').include?("command_test.txt")).to be_truthy
  end

  it 'deletes category file' do
    command = Command.new(@category, 'delete, command_test')
    command.execute
    expect(Dir.entries('categories').include?("command_test.txt")).to be_falsy
  end

  it 'adds card to category' do
    command = Command.new(@category, 'add, front, back, test')
    command.execute
    @category.read_file
    expect(@category.card_list.last.front).to eq('front')
  end

  it 'removes card from category' do
    command = Command.new(@category, 'remove, front, test')
    command.execute
    @category.read_file
    expect(@category.card_list.last.front).to eq('java')
  end
end
