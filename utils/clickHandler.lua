function checkWhichBlock(mx,my)
    --check the collision
    local spacing = interSpace
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
    --if destiny<origin then return false end

    local y1,x1 = math.floor((origin-1)/boardW)+1, ((origin-1)%(boardW))+1
    local y2,x2 = math.floor((destiny-1)/(boardW))+1, ((destiny-1)%(boardW))+1

    if destiny==origin then return "h" end -- garante bonito no primeiro

    if y1==y2 and destiny>origin then return "h" end
    if x1==x2 and destiny>origin then return "v" end
    if x1-y1==x2-y2 and destiny>origin then return "d" end
    if x1+y1==x2+y2 and destiny>origin then return "sd" end


    if y1==y2 then return "hb" end
    if x1==x2 then return "vb" end
    if x1-y1==x2-y2 then return "db" end
    if x1+y1==x2+y2 then return "sdb" end


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
    elseif directionClick=="hb" then
        for i=destiny,origin do
            obj=obj..board[i]
        end
        obj = invertWord(obj)
    elseif directionClick=="v" then
        for i=origin,destiny,boardW do
            obj=obj..board[i]
        end
    elseif directionClick=="vb" then
        for i=destiny,origin,boardW do
            obj=obj..board[i]
        end
        obj = invertWord(obj)
    elseif directionClick=="d" then
        for i=origin,destiny,boardW+1 do
            obj=obj..board[i]
        end
    elseif directionClick=="db" then
        for i=destiny,origin,boardW+1 do
            obj=obj..board[i]
        end
        obj = invertWord(obj)
    elseif directionClick=="sd" then
        for i=origin,destiny,boardW-1 do
            obj=obj..board[i]
        end
    elseif directionClick=="sdb" then
        for i=destiny,origin,boardW-1 do
            obj=obj..board[i]
        end
        obj = invertWord(obj)
    end
    return obj
end

function checkButtons(mx,my)
    local androidFactor = 0.25
    if checkMobile() then androidFactor=0.15 end  
    local buttonWidth = 256*androidFactor
    local buttonHeight = 256*androidFactor
    local minPadding = 10
    local numButtons = #buttons
    local totalButtonsWidth = numButtons * buttonWidth
    local totalPadding = math.max((screenw - totalButtonsWidth) / (numButtons + 1), minPadding)
    local xStart = (screenw - (totalButtonsWidth + totalPadding * (numButtons - 1))) / 2
    local y = screenh - buttonHeight - 20
    for i, btn in ipairs(buttons) do
        local x = xStart + (i - 1) * (buttonWidth + totalPadding)
        if mx >= x and mx <= x+buttonWidth and my >= y and my <= y+buttonHeight then
            return i
        end
    end
end

function settingsCollision(mx,my)
    local widthScale = 1.2
    if checkMobile()==false then widthScale=2.5 end
    local w = screenw/widthScale
    local h = screenh/1.5
    local x = screenw/2-w/2+15
    local y = screenh/2-h/2
    local width=w-30
    y=y+font:getHeight()*2+textfont:getHeight()+5
    y=y+font:getHeight()+18
    for i,v in pairs(settings) do
        x=screenw/2-w/2+15
        local size = math.max(font:getWidth("+"),font:getHeight())
        if mx >= x and mx <= x+size and my >= y and my <= y+size then
            return "minus", i
        end
        x=x+width-size
        if mx >= x and mx <= x+size and my >= y and my <= y+size then
            return "plus", i
        end
        y=y+font:getHeight()*2+textfont:getHeight()+5
    end

end
