require_relative '../category'
require_relative '../card'

RSpec.describe Category do
  before(:each) do
    @card = Card.new('java', 'object oriented programming language')
    @category = Category.new('test.txt')
    @category.add_card(@card)
  end

  it 'reads category file' do
    category = Category.new('test.txt')
    category.read_file
    expect(category.card_list[0].front).to eq('java')
    expect(category.card_list[0].point).to eq('0')
  end

  it 'adds card to category' do
    card = Card.new('html', 'the standard markup language for creating web pages and web applications')
    @category.add_card(card)
    expect(@category.card_list).to include(card)
  end

  it 'removes card from category' do
    card = Card.new('html', 'the standard markup language for creating web pages and web applications')
    @category.add_card(card)
    @category.remove_card('html')
    expect(@category.card_list).not_to include(card)
  end

  it 'writes changes to category file' do
    card = Card.new('html', 'the standard markup language for creating web pages and web applications')
    @category.add_card(card)
    @category.write_to_file('test')
    @category.remove_card('html')
    @category.write_to_file('test')
  end
end
