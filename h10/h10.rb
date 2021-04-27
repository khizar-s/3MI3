require 'date'
require_relative 'collection'

Pair = Struct.new(:fst,:snd)

def summingPairs(xs, sum)
    the_pairs = []
    len = xs.length
  
    reader, writer = IO.pipe
    for i in 0..(len-1)
      fork do
        for j in (i+1)..(len-1)
          if xs[i] + xs[j] <= sum
            res = "#{xs[i]}|#{xs[j]}"
            writer.puts(res)
          end
        end
      end
    end
    writer.close
  
    Process.waitall
    until reader.eof?
      first, second = reader.gets.split('|')
      pair = Pair.new(first.to_i, second.to_i)
      the_pairs.push(pair)
    end
    return the_pairs
end