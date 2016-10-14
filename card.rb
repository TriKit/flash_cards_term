require 'rainbow/ext/string'

# CARD
class Card
  attr_accessor :front, :back, :point

  def initialize(front, back, point = 0)
    @front = front
    @back = back
    @point = point
  end

  def line_to_file
    "#{@front}, #{@back}, #{@point}"
  end

  def print_card
    "front: #{@front}, back: #{@back}"
  end

  def change_point(point)
    point = point.to_i
    if (0..2).cover?(point)
      @point = point
      show_message("set point #{point}") { |m| m.color(:mintcream) }
    else
      show_message('Point must be 1, 2 or 3.') { |m| m.color(:red) }
    end
  end

  def show_front
    puts '----------------------------------------'
    show_message(@front.upcase) { |m| m.color(:mintcream) }
    puts '----------------------------------------'
  end

  def show_back
    l = @back.length
    l.times { print '-' }
    print "\n"
    show_message(@back) { |m| m.color(:mintcream) }
    l.times { print '-' }
    print "\n"
  end
end
