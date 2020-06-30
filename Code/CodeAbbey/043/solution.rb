data = IO.read('dice_rolling_data.txt')
data = data.split("\n")
for i in 0...data.size
	data[i] = ((data[i].to_f * 6)+1).floor
end

p data[1..data.size].join " "