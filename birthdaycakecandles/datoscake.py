f = open ('DATA.lst','r')
mensaje = f.read()

data = [mensaje]

print ("--------------- ARREGLO CON LA DATA ------------------")
print ()

for line in data:
    typeData = line.split()
    # print (typeData)

for i in range(0, len(typeData)):
    typeData[i] = int(typeData[i])

print (typeData)

print ()

dataTres = typeData.count(82)

print ("--------------- CANTIDAD REPETIDA ------------------")
print ()

print (dataTres)

f.close()