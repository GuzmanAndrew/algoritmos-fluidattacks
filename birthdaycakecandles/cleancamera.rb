# frozen_string_literal: true

# rubocop cleancamera.rb
# 1 file inspected, no offenses detected

data = ''

File.open('DATA.lst', 'r') do |lines|
  line = lines.gets
  data = line
end

data_count = data.split.count('82')

puts(data_count)

# ruby cleancamera.rb
# OutPut:
# 5
