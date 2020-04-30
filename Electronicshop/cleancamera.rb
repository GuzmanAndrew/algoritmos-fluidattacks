---------------------------------------------------------------- PRIMERA SOLUCION -----------------------------------------------
"""
D  K U
10 2 3
3 1
5 2 8

9

EXPLICACION: Monica tiene 10 dolares, hay dos tipos de teclados es decir dos modelos y 3 modelos de USB, 
el primer modelo de teclado cuesta 3 dolares y el segundo modelo 1 dolar. 
El primer modelo de USB cuesta 5 dolares 
el segundo modelo 2 dolares y el tercero 8 dolares

Ella puede comprar el 2º teclado y la 3ª unidad USB por un coste total de 8+1 = 9.

5 1 1
4
5

-1

No hay forma de comprar un teclado y una unidad USB porque 4 + 5 > 5, así que imprimimos -1.

"""
"""
a = [1, 3, 4, 5]
b = [2, 3, 1, 5, 6]
Uso -1 (índice de índices negativos contar hacia atrás desde el final de la matriz):
a[-1] # => 5
b[-1] # => 6
o Array#last método de:

a.last # => 5
b.last # => 6
"""

b = 10
kb = [3, 1]
dr = [5, 2, 8]

def getMoneySpent(keyboards, drivers, b)
    cShop = keyboards[-1] + drivers[-1]
    if cShop <= b
        puts(cShop)
    elsif cShop > b
        puts('-1')
    end
end

getMoneySpent(kb, dr, b)

------------------------------------------------- SEGUNDA SOLUCION ---------------------------------------------------

# frozen_string_literal: true

# rubocop cleancamera.rb
# 1 file inspected, no offenses detected

data = ''
keyboard = ''
driver = ''
money = ''

File.open('DATA.lst', 'r') do |lines|
  line = lines.gets
  data = line
end

data_spl = data.split(' ')

keyboard = data_spl[0] if data_spl[0].eql? data_spl[0]
driver = data_spl[1] if data_spl[1].eql? data_spl[1]
money = data_spl[2] if data_spl[2].eql? data_spl[2]

def get_money_spent(keyboards, drivers, money)
  num_keyboad = keyboards[-1].to_i
  num_driver = drivers[-1].to_i
  money_user = money.to_i
  shop_cart = num_keyboad + num_driver
  if shop_cart <= money_user
    puts(shop_cart)
  elsif shop_cart > money_user
    puts('-1')
  end
end

get_money_spent(keyboard, driver, money)

# ruby cleancamera.rb
# OutPut:
# 9

