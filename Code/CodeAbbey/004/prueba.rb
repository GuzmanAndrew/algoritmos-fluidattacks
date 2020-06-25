class MayorMenorVector
    def solucion(a)
        menor = a[0]

        for x in 0..1
            if a[x] < menor
                menor = a[x]
            end
        end
        puts "EL numero menor es: ", menor
    end
end

a = [5, 8]
obj = MayorMenorVector.new
obj.solucion(a)