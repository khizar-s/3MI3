def fizzbuzzLooper(inp)
    res = []
    for x in inp
        res.append("fizzbuzz") if x % 5 == 0 && x % 3 == 0
        res.append("fizz") if x % 5 != 0 && x % 3 == 0
        res.append("buzz") if x % 5 == 0 && x % 3 != 0
        res.append(x.to_s) if x % 5 != 0 && x % 3 != 0
    end
    return res
end

def fizzbuzzIterator(inp)
   res = []
   inp.each do |x|
    res.append("fizzbuzz") if x % 5 == 0 && x % 3 == 0
    res.append("fizz") if x % 5 != 0 && x % 3 == 0
    res.append("buzz") if x % 5 == 0 && x % 3 != 0
    res.append(x.to_s) if x % 5 != 0 && x % 3 != 0
   end
   return res
end

def zuzzer(list, rules)
    res = []
    list.each do |item|
        val = ""
        rules.each do |rule|
            val += rule[1].call(item) if rule[0].call(item)
        end
        (val == "") ? res.append(item.to_s) : res.append(val)
    end
    return res
end