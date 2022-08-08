ary = [1,1,15,2,20]

ret = false
for i in 0...(ary.size)
  if ary[i] >= 5
    ret = true
    break
  end
end
