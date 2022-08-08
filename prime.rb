count1 = 0

if (number==0)
    puts "0 is not a prime number"
else
    count2 = 2
    while(count2 < number)
        if (number % count2 == 0)
            count1 += 1
        end
        count2 += 1
    end
end
if count1 >1
    puts "#{number} is not a prime number"
else
    puts "#{number} is a prime number"
end
