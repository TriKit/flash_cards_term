require_relative '../card'
require 'spec_helper'

RSpec.describe Card do
  before(:each) do
    @card = Card.new('ruby', 'dynamic programming language')
  end

  it 'prepares a line to be written to the file' do
    expect(@card.line_to_file).to eq('ruby, dynamic programming language, 0')
  end

  it 'prepares card to show' do
    expect(@card.print_card).to eq('front: ruby, back: dynamic programming language')
  end

  describe 'set_point' do
    it 'sets card point if point is valid' do
      @card.set_point(2)
      expect(@card.point).to eq(2)
    end

    it 'not sets card point if point is not valid' do
      @card.set_point(4)
      expect(@@last_message).to eq('Point should be 1, 2 or 3')
      # expect(@card.point).not_to eq(4)
    end
  end
end
