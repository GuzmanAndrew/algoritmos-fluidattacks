def titleize(str)
    str.split().map(&:capitalize).join(" ")
end

File.open('DATA.lst', 'r') do |f1|
    while linea = f1.gets
        puts(titleize(linea))
    end
end

# http://rubytutorial.wikidot.com/lectura-escritura
