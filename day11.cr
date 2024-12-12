module AoC24::Day11
  struct Stone
    getter value : UInt64

    def initialize(@value : UInt64)
    end


    private def assemble_u32(digits : Enumerable(Int)) : UInt64
      total : UInt64 = 0
      power : UInt64 = 1

      digits.each do |digit|
        total += digit * power
        power *= 10_u32
      end

      total
    end


    def split : Tuple(Stone, Stone)
      digits = @value.digits
      halfway = digits.size // 2

      {Stone.new(assemble_u32(digits[(halfway..)])),
       Stone.new(assemble_u32(digits[(0...halfway)]))}
    end


    def splittable? : Bool
      Math.log10(@value.succ).ceil.to_i.even? && !@value.zero?
    end


    def blink : Stone | Tuple(Stone, Stone)
      return split if splittable?

      if @value.zero?
        @value = 1
      else
        @value *= 2024
      end

      self
    end
  end


  class StoneLine
    @stones = Array(Stone).new


    delegate size, to: @stones


    def initialize(input : IO | String)
      input.each_line do |line|
        line.split.each do |number|
          @stones << Stone.new number.to_u32
        end
      end
    end


    def blink
      @stones.reduce([] of Stone) do |result, stone|
        # What **would** have been nice is splatting a union:
        # where I could have done `result.push *stone.blink`.
        # Apparently that's something the compiler explicitly
        # catches and points out that's not supported..._yet_.
        #
        # In the meantime, I got this `case` situation to
        # handle the syntax of that.

        case b = stone.blink
        when Stone then result.push b
        else result.push *b
        end
      end
    end


    def blink!
      # Because there's no `reduce!` method...
      @stones = blink
    end
  end
end


row = AoC24::Day11::StoneLine.new STDIN

# Part 1
25.times do
  row.blink!
end

puts row.size
