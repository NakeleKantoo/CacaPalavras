function checkWhichBlock(mx,my)
    --check the collision
    local spacing = 2
    local maxW = (blockW+spacing)*boardW
    local maxH = (blockH+spacing)*boardH
    local x = screenw/2-maxW/2
    local y = screenh/2-maxH/2

    for i=1,#board do
        if mx >= x and mx <= x+blockW and my >= y and my <= y+blockH then
            return i
        end
        x=x+blockW+spacing
        if i%boardW==0 then y=y+blockH+spacing; x=screenw/2-maxW/2 end
    end
    return 0
end
