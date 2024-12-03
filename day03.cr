input = STDIN.gets_to_end

total = 0
pos   = 0

while m = input.match(/mul\((\d{1,3}),(\d{1,3})\)/, pos)
  total += m[1].to_i * m[2].to_i
  pos = m.end
end

puts total
