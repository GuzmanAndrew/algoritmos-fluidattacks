def read_data_file()
    data = File.read("DATA.lst")
    values = [] of Array(UInt64)
    data.each_line do |x|
        inter = [] of UInt64
        (x.split).each do |y|
            y = y.to_u64
            inter << y
        end
        values << inter
    end
    values[1..]
end

def checksum(array)
    result = 0
    limit = 10000007
    array.each do |x|
        result = ( result + x ) * 113
    end
    val = result % limit
    puts val
end

get_data = read_data_file()
get_data.each do |x|
    checksum(x)
end
