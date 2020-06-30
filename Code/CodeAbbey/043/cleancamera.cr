def data_entry()
    data = File.read("DATA.lst")
    values = [] of Array(Float64)
    data.each_line do |x|
        inter = [] of Float64
        (x.split).each do |y|
            y = y.to_f
            inter << y
        end
        values << inter
    end
    values[1..]
end

def number_dice(array)
    result = 0
    array.each do |x|
        x = ((x.to_f * 6)+1).floor
        result = x
    end
    puts result.to_i
end
  
data = data_entry()
data.each do |x|
    number_dice(x)
end
