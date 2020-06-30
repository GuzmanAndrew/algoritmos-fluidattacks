data = IO.read('array_checksum_data.txt')
result = 0
limit = 10000007
data = data.split("\n")
data.delete_at(0)
data = data[0].split(" ")
for i in 0...data.size
	data[i] = data[i].to_i
end

for i in 0...data.size
	result = ( result + data[i] ) * 113
end

p result % limit
