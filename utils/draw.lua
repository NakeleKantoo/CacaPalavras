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
    local txt = ""
    for i,v in ipairs(palavras) do
        if txt=="" then
            txt=v
        else
            txt=txt.." - "..v
        end
    end
    txt=string.upper(txt)
    local maxW = (textfont:getWidth(txt)+20)
    local x = screenw/2-maxW/2
    local y = 15

    --draw back
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle('fill',x,y,maxW,textfont:getHeight()+10,15)
    y=y+5
    love.graphics.setColor(0,0,0)
    love.graphics.printf(txt,textfont,x,y,maxW,"center")
end

function drawLine()
    local mx,my = love.mouse.getPosition()
    local spacing = 2
    local maxW = (blockW+spacing)*boardW
    local maxH = (blockH+spacing)*boardH
    local x = screenw/2-maxW/2
    local y = screenh/2-maxH/2
    for i=1,#board do
        if i == clicked then break end
        x=x+blockW+spacing
        if i%boardW==0 then y=y+blockH+spacing; x=screenw/2-maxW/2 end
    end
    x=x+(blockW/4)
    y=y+(blockH/4)

    love.graphics.setLineWidth(blockW)
    love.graphics.setColor(1,0.9,0.1,0.3)
    love.graphics.line(mx,my,x,y)
end

