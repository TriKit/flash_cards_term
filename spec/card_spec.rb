require_relative "../card"

RSpec.describe Card do

  it "prepares a line to be written in to the file" do
    card = Card.new('ruby', 'dynamic programming language')
    expect(card.line_to_file).to eq("ruby, dynamic programming language, 0")
  end

  it "prepares card to show" do
    card = Card.new('ruby', 'dynamic programming language')
    expect(card.print_card).to eq("front: ruby, back: dynamic programming language")
  end
end
