struct Report
  @contents : Array(Int32)

  def initialize(line : String)
    reports = line.split

    raise "Reports need at least two items." if reports.size < 2

    @contents = reports.map(&.to_i)
  end

  def safe?
    # Direction of previous cons; starting with the first cons
    dir = (@contents[0] - @contents[1]).sign

    @contents.each_cons_pair.all? do |i, j|
      diff = i - j # Negative when ascending, positive when descending

      # All in the same order and differ between 1 and 3.
      (dir == diff.sign)       && (1..3).includes? diff.abs
    end
  end
end

# Part 1
puts STDIN.each_line.count {|line|
  Report.new(line).safe?
}
