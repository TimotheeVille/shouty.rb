class Coordinate
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def distance_from(other)
    # Calculate Euclidean distance between two coordinates.
    # NOTE: If only axis-aligned distances are needed, this can be simplified,
    # but specs include diagonal expectation.
    dx = (@x - other.x).abs
    dy = (@y - other.y).abs
    return 0 if dx.zero? && dy.zero?
    Math.sqrt(dx * dx + dy * dy).to_i
  end
end
