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
    menor = [] of Int32
  
    if array[0] < array[1]
        menor << array[0]
    elsif array[1] < array[0]
        menor << array[1]
    end

    puts menor
  
end
  
data = data_entry()
data.each do |x|
    rounding(x)
end
