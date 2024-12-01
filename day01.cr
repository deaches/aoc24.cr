ours   = [] of Int32
theirs = [] of Int32

STDIN.each_line do |line|
  row     = line.split.map(&.to_i)
  ours   << row[0]
  theirs << row[1]
end

# Part 1
puts ours.sort.zip(theirs.sort).map {|row|
  row.max - row.min
}.sum

# Part 2
puts ours.uniq.map {|first|
  first * theirs.count first
}.sum
