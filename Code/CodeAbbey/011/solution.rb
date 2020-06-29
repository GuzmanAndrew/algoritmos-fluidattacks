data = IO.read('sum_of_digits_data.txt')
data = data.split("\n")
data_sanitized = []
totals = []
for i in 1...data.size
	data[i] = data[i].split(" ")
end

data.each do |group|
	if group.size >= 3
		for i in 0...group.size
			group[i] = group[i].to_i
		end
		data_sanitized.push(group)
	end
end

data_sanitized.each do |group|
	total = group[0] * group[1] + group[2]
	total = total.to_s.split("")
	for i in 0...total.size
		total[i] = total[i].to_i
	end
	total =	total.reduce(:+)
	totals.push(total)
end

p totals.join " "