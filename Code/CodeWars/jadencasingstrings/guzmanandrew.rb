# frozen_string_literal: true

# 1 file inspected, no offenses detected

def titleize(str)
  str.split.map(&:capitalize).join(' ')
end

File.open('DATA.lst', 'r') do |f1|
  while (linea = f1.gets)
    puts(titleize(linea))
  end
end

# ruby guzmanandrew.rb
# OutPut:
# How Can Mirrors Be Real If Our Eyes Aren't Real
