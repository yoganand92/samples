def find_missing(array)
    (1..10).each do |item|
    found = false 
        array.each do |number|
            if item == number
                found = true
                break
            end
        end
        if found == false
            return item 
        end
    end
end

array = [1, 2, 3, 4, 5, 6, 7, 8, 10]
