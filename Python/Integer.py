from Object import Object

class Integer(Object):
    def __init__(self, value):
        self.value = value
    

    def __str__(self):
        return self.value


    def binary(self):
        n = self.value
        binary_array = []
        res = ""
    
        i = 0
        while (n > 0):
            binary_array.append(n % 2)
            n = n // 2
            i += 1

        for i in range(len(binary_array)-1, -1, -1):
            res += str(binary_array[i])

        return res
