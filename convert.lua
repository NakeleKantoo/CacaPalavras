local args = arg
function trunc(num, digits)
  local mult = 10^(digits)
  return math.modf(num*mult)/mult
end

print(trunc(arg[1]/255,3)..", "..trunc(arg[2]/255,3)..", "..trunc(arg[3]/255,3))
