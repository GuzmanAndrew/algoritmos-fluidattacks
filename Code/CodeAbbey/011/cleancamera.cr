def data_entry()
    data = File.read("DATA.lst")
    values = [] of Array(Int32)
    data.each_line do |x|
        inter = [] of Int32
        (x.split).each do |y|
            y = y.to_i
            inter << y
        end
        values << inter
    end
    values[1..]
end

def rounding(array)
    total = array[0] * array[1] + array[2]
    total = total.to_s.split("")
    result = [] of Int32
    total.each do |x|
        total = x.to_i
        result << total
    end
    result = result.reduce(0) { |sum, num| sum + num }
    puts result
end
  
data = data_entry()
data.each do |x|
    rounding(x)
end
