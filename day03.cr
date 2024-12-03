input = STDIN.gets_to_end

p1_pos = 0
p2_pos = 0
p1_total = 0
p2_total = 0
enabled = true

p1_inst = /(mul)\((\d{1,3}),(\d{1,3})\)/
p2_inst = p1_inst +
          /(do)\(\)/ +
          /(don't)\(\)/

# Part 1
while p1_m = input.match(p1_inst, p1_pos)
  p1_total += p1_m[2].to_i * p1_m[3].to_i

  p1_pos = p1_m.end
end

# Part 2
while p2_m = input.match(p2_inst, p2_pos)
  # Rather than named instructions, captures seem to be mutually exclusive
  # in the union, so mul *only* has indexes 1-3.
  # Only index 4 will be non-nil if running "do" and index 5 if "don't".

  enabled = true  if p2_m[4]?
  enabled = false if p2_m[5]?
  p2_total += p2_m[2].to_i * p2_m[3].to_i if enabled && p2_m[1]?

  p2_pos = p2_m.end
end

puts p1_total
puts p2_total
