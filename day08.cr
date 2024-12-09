struct Position
  getter x : Int32,
         y : Int32

  def initialize(@x = 0, @y = 0)
  end

  def to_t
    {@x, @y}
  end
end

class Antenna
  getter frequency : Char,
         position  : Position

  def initialize(@frequency, x = 0, y = 0)
    raise "Invalid frequency '%c'" % @frequency unless @frequency.ascii_alphanumeric?

    @position = Position.new x, y
  end

  # Note that RISE increases downwards; run rises to the right.
  # Negative values go up and left.
  def slope(other : Antenna)
    {rise: other.position.y - @position.y,
     run:  other.position.x - @position.x}
  end

  # Find the antinodes between two Antennas of the same frequency.
  def antinodes(other : Antenna) : Tuple(Position, Position)
    raise "Frequencies '%c' and '%c' do not match" % [
      @frequency, other.frequency
    ] if @frequency != other.frequency

    s = slope(other)

    {Position.new(@position.x - s[:run], @position.y - s[:rise]),
     Position.new(other.position.x + s[:run], other.position.y + s[:rise])}
  end
end


class FrequencyScan
  getter height : Int32,
         width  : Int32
  
  def initialize(input : IO | String)
    lines = input.each_line

    @scan   = {} of Position => Antenna
    @height = lines.size
    @width  = 0

    input.each_line.each_with_index do |line, i|
      # Shouldn't be larger than the first row.
      # Buuuuuut...
      line_width = line.size.succ
      @width = line_width if line_width > @width

      line.each_char.with_index do |ch, j|
        unless ch == '.'
          pos = Position.new i, j
          @scan[pos] = Antenna.new ch, i, j
        end
      end
    end
  end

  def at(pos : Position) : Antenna?
    @scan[pos]?
  end

  def at(x, y) : Antenna?
    at Position.new x, y
  end

  def locations(of : Char) : Array(Antenna)
    @scan.select {|k, v| v.frequency == of}.values
  end

  # Returns a hash keyed with a frequency character
  # valued with an array of locations.
  def to_h : Hash(Char, Array(Antenna))
    hash = Hash(Char, Array(Antenna)).new {|h, k| h[k] = Array(Antenna).new }

    @scan.each_key do |pos|
      ant = at(pos).not_nil!
      hash[ant.frequency] << ant
    end
    
    hash
  end

  # Return the number of unique antinodes for each antenna on the map.
  # Solves part 1 of the day's challenge.
  def part1
    antinodes = Set(Position).new

    # TODO: fix. This just looks jank.
    to_h.each_value do |ants|
      ants.combinations(2).map {|pair| pair[0].antinodes pair[1] }.each do |ans|
        ans.each do |a|
          antinodes << a if 0 <= a.x < @width && 0 <= a.y < @height
        end
      end
    end

    antinodes.size
  end
end


example = <<-END
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
END

scan = FrequencyScan.new example
pp scan.part1
