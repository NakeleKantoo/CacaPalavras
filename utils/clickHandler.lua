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

function checkDirection(origin,destiny)
    if destiny<origin then return false end

    if destiny-origin<boardW then return "h" end
    if (destiny-origin)%boardW==0 then return "v" end
    if (destiny-origin)%boardW<boardW then return "d" end

    return false

    --check for diagonal first?
    --x+i-1+((y+i-1)*boardW)

end

function checkWord(origin,destiny,dir)
    local obj = ""
    if directionClick=="h" then
        for i=origin,destiny do
            obj=obj..board[i]
        end
    elseif directionClick=="v" then
        for i=origin,destiny,boardW do
            obj=obj..board[i]
        end
    elseif directionClick=="d" then
        for i=origin,destiny,boardW+1 do
            obj=obj..board[i]
        end
    end
    return obj
end
