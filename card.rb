class Card
  attr_accessor :front, :back, :point

  def initialize(front, back, point=0)
    @front = front
    @back = back
    @point = point
  end

  def line_to_file
    "#{@front}, #{@back}, #{@point}"
  end

  def print_card
    puts "front: #{@front}, back: #{@back}, point: #{@point}"
  end
end
