require("love")

function drawBackground()
    love.graphics.setColor(0.3,0.3,0.55)
    love.graphics.rectangle('fill',0,0,screenw,screenh)
end

function drawBoard()
    local spacing = 2
    local maxW = (blockW+spacing)*boardW
    local maxH = (blockH+spacing)*boardH
    local x = screenw/2-maxW/2
    local y = screenh/2-maxH/2
    for i=1,#board do
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle('fill',x,y,blockW,blockH)
        love.graphics.setColor(0,0,0)
        love.graphics.printf(string.upper(board[i]),font,x,y,blockW,"center")
        x=x+blockW+spacing
        if i%boardW==0 then y=y+blockH+spacing; x=screenw/2-maxW/2 end
    end
end

function drawWords()
    local txt = {}
    for i,v in ipairs(palavras) do
        local color = {0,0,0}
        for i=1,#achadas do if achadas[i]==v then color = {0,0.8,0} end end
        if i==1 then
            txt[#txt+1] = color
            txt[#txt+1] = string.upper(v)
        else
            txt[#txt+1] = {0,0,0}
            txt[#txt+1] = " - "
            txt[#txt+1] = color
            txt[#txt+1] = string.upper(v)
        end
    end
    local wowText = ""
    for i,v in ipairs(txt) do
        if i%2==0 then wowText=wowText..v end
    end
    local maxW = math.min(textfont:getWidth(wowText)+20,screenw-50)
    local h = textfont:getHeight()+10
    if maxW==screenw-50 then
        h = (h-10)*2+10
    end
    local x = screenw/2-maxW/2
    local y = 15

    --draw back
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle('fill',x,y,maxW-10,h,15)
    y=y+5
    --love.graphics.setColor(0,0,0)
    love.graphics.printf(txt,textfont,x,y,maxW,"center")
end

function drawLine()

    if directionClick==false then return false end

    local spacing = 2
    local maxW = (blockW+spacing)*boardW
    local maxH = (blockH+spacing)*boardH
    local x = screenw/2-maxW/2
    local y = screenh/2-maxH/2
    local mx = screenw/2-maxW/2
    local my = screenh/2-maxH/2
    for i=1,#board do
        if i == clicked then break end
        x=x+blockW+spacing
        if i%boardW==0 then y=y+blockH+spacing; x=screenw/2-maxW/2 end
    end
    for i=1,#board do        
        if i == destinyClick then break end
        mx=mx+blockW+spacing
        if i%boardW==0 then my=my+blockH+spacing; mx=screenw/2-maxW/2 end
    end
    if directionClick=="h" then
        --x=x+(blockW/4)
        y=y+(blockH/2)
        my=my+(blockH/2)
        mx=mx+blockW+spacing
    elseif directionClick=="v" then
        x=x+(blockW/2)
        mx=mx+(blockW/2)
        my=my+blockH+spacing
    elseif directionClick=="d" then
        x=x+(blockW/4)
        y=y+(blockH/4)
        mx=mx+blockW+spacing
        my=my+blockH+spacing
    end

    love.graphics.setLineWidth(blockW)
    love.graphics.setColor(1,0.9,0.1,0.3)
    love.graphics.line(mx,my,x,y)
end


function drawFoundLines()
    for i,v in ipairs(lines) do

        local spacing = 2
        local maxW = (blockW+spacing)*boardW
        local maxH = (blockH+spacing)*boardH
        local x = screenw/2-maxW/2
        local y = screenh/2-maxH/2
        local mx = screenw/2-maxW/2
        local my = screenh/2-maxH/2
        for i=1,#board do
            if i == v.origin then break end
            x=x+blockW+spacing
            if i%boardW==0 then y=y+blockH+spacing; x=screenw/2-maxW/2 end
        end
        for i=1,#board do        
            if i == v.destiny then break end
            mx=mx+blockW+spacing
            if i%boardW==0 then my=my+blockH+spacing; mx=screenw/2-maxW/2 end
        end
        if v.direction=="h" then
            --x=x+(blockW/4)
            y=y+(blockH/2)
            my=my+(blockH/2)
            mx=mx+blockW+spacing
        elseif v.direction=="v" then
            x=x+(blockW/2)
            mx=mx+(blockW/2)
            my=my+blockH+spacing
        elseif v.direction=="d" then
            x=x+(blockW/4)
            y=y+(blockH/4)
            mx=mx+blockW+spacing
            my=my+blockH+spacing
        end

        love.graphics.setLineWidth(blockW)
        love.graphics.setColor(1,0.9,0.1,0.3)
        love.graphics.line(mx,my,x,y)
    end
end
