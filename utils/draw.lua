require("love")

function drawBackground()
    love.graphics.setColor(drawColors.gameBack)
    love.graphics.rectangle('fill',0,0,screenw,screenh)
end

function drawBoard()
    local spacing = interSpace
    local maxW = (blockW+spacing)*boardW
    local maxH = (blockH+spacing)*boardH
    local x = screenw/2-maxW/2
    local y = screenh/2-maxH/2

    --shading :)
    love.graphics.setColor(drawColors.shading)
    love.graphics.rectangle('fill',x+10,y+10,maxW,maxH)

    for i=1,#board do
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle('fill',x,y,blockW,blockH)
        love.graphics.setColor(0,0,0)
        love.graphics.printf(string.upper(board[i]),font,x,y+((blockH-spacing*2)/2-textfont:getHeight()/2-(blockH-spacing)/10),blockW,"center")
        x=x+blockW+spacing
        if i%boardW==0 then y=y+blockH+spacing; x=screenw/2-maxW/2 end
    end
end

function drawWords()
    local txt = {}
    for i,v in ipairs(palavras) do
        local color = {1,1,1}
        for i=1,#achadas do if achadas[i]==v then color = drawColors.foundWord end end
        if i==1 then
            txt[#txt+1] = color
            txt[#txt+1] = string.upper(v)
        else
            txt[#txt+1] = {1,1,1}
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
        local scaleFact = math.ceil((textfont:getWidth(wowText)+20)/(screenw-50))
        h = (h-10)*scaleFact+10
    end
    local x = screenw/2-maxW/2
    local y = 15

    --draw shading
    love.graphics.setColor(drawColors.shading)
    love.graphics.rectangle('fill',x+5,y+5,maxW+5,h)

    --draw back
    love.graphics.setColor(drawColors.back)
    love.graphics.rectangle('fill',x,y,maxW+5,h)
    y=y+5

    printf(txt,textfont,x+5,y,maxW-5,"center",{1,1,1},drawColors.shading,2)
end

function drawLine()

    if directionClick==false then return false end

    local spacing = interSpace
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
    x,y,mx,my = calcDir(x,y,mx,my,spacing,directionClick)

    love.graphics.setLineWidth(blockW)
    love.graphics.setColor(currentColor)
    love.graphics.line(mx,my,x,y)
end


function drawFoundLines()
    for i,v in ipairs(lines) do

        local spacing = interSpace
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
        x,y,mx,my = calcDir(x,y,mx,my,spacing,v.direction)

        love.graphics.setLineWidth(blockW)
        love.graphics.setColor(v.color)
        love.graphics.line(mx,my,x,y)
    end
end

function drawDock()
    local androidFactor = 0.25
    if checkMobile() then androidFactor=0.15 end  
    local buttonWidth = 256*androidFactor -- Largura dos botões (ajuste conforme necessário)
    local buttonHeight = 256*androidFactor -- Altura dos botões (ajuste conforme necessário)
    local minPadding = 10 -- Espaçamento entre os botões (ajuste conforme necessário)
    local numButtons = #buttons

     -- Calcula o total de largura ocupada pelos botões
    -- Calcula a largura total ocupada pelos botões
    local totalButtonsWidth = numButtons * buttonWidth

    -- Calcula o padding necessário para centralizar os botões
    local totalPadding = math.max((screenw - totalButtonsWidth) / (numButtons + 1), minPadding)

    -- Calcula a posição x inicial para o primeiro botão
    local xStart = (screenw - (totalButtonsWidth + totalPadding * (numButtons - 1))) / 2


    -- Calcula a posição y dos botões colados na parte inferior da tela
    local y = screenh - buttonHeight - 20

    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, y, screenw, screenh-y)
    love.graphics.setColor(1,1,1,1)
    for i, btn in ipairs(buttons) do
        local x = xStart + (i - 1) * (buttonWidth + totalPadding)
        love.graphics.draw(btn.img, x, y + 10, 0, androidFactor)
    end
end

function drawSettings()
    --grey out the background
    love.graphics.setColor(0,0,0,0.25)
    love.graphics.rectangle('fill',0,0,screenw,screenh)

    --draw the back of menu

    local w = screenw/1.2
    local h = screenh/1.5
    local x = screenw/2-w/2
    local y = screenh/2-h/2

    --shading
    love.graphics.setColor(drawColors.shading)
    love.graphics.rectangle("fill",x+15,y+15,w,h)

    --actual back
    love.graphics.setColor(drawColors.back)
    love.graphics.rectangle("fill",x,y,w,h)

    --text
    printf("Configurações",font,x,y+15,w,"center",{1,1,1},drawColors.shading,5,drawColors.underline)

    settingsOption("Teste","testando",w-30,x+15,y+h/2)
end


function calcDir(x,y,mx,my,spacing,directionClick)
    if directionClick=="h" then
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
    elseif directionClick=="hb" then
        x=x+(blockW+spacing)
        y=y+(blockH/2)
        my=my+(blockH/2)
    elseif directionClick=="vb" then
        x=x+(blockW/2)
        y=y+blockH+spacing
        mx=mx+(blockW/2)
    elseif directionClick=="db" then
        x=x+blockW+spacing
        y=y+blockH+spacing
    elseif directionClick=="sd" then
        x=x+blockW+spacing-(blockW/4)
        y=y+(blockH/4)
        my=my+blockH+spacing
    elseif directionClick=="sdb" then
        x=x+(blockW/4)
        y=y+blockH+spacing-(blockH/4)
        mx=mx+blockW+spacing
    end
    return x,y,mx,my
end

function printf(text,font,x,y,limit,align,color,shading,shspace,underline)
    if shading then
        shspace=shspace or 3
        love.graphics.setColor(shading)
        love.graphics.printf(text,font,x+shspace,y+shspace,limit,align)
    end
    love.graphics.setColor(color)
    love.graphics.printf(text,font,x,y,limit,align)
    if underline then
        local w = font:getWidth(text)
        local ny = y+font:getHeight()
        local nx = x-3
        if align=="center" then nx = math.abs(limit/2+x-w/2)-3 end
        love.graphics.setColor(underline)
        love.graphics.rectangle("fill",nx,ny+3,w+6,5,2)
    end
end

function drawButton(text,font,x,y,w,h,color,textcolor,shading,textshading)
    if shading then
        love.graphics.setColor(shading)
        love.graphics.rectangle("fill",x+5,y+5,w,h)
    end
    love.graphics.setColor(color)
    love.graphics.rectangle("fill",x,y,w,h)
    local ty = y+h/2-font:getHeight()/2
    printf(text,font,x,ty,w,"center",textcolor,textshading,2)
end

function settingsOption(text,value,width,x,y)
    printf(text,font,x,y,width,"center",{1,1,1},drawColors.shading,2)
    y=y+font:getHeight()+3
    local size = math.max(font:getWidth("+"),font:getHeight())
    buttonWrapper("-",x,y,size,size)
    printf(value,textfont,x,y,width,"center",{1,1,1},drawColors.shading,2)
    buttonWrapper("+",x+width-size,y,size,size)
end

function buttonWrapper(text,nx,ny,nw,nh)
    local btnColor = drawColors.button
    local mx,my=love.mouse.getPosition()
    if mx >= nx and mx <= nx+nw and my >= ny and my <= ny+nh then
        btnColor=drawColors.buttonHighlight
        if love.mouse.isDown(1) then
            btnColor=drawColors.buttonPress
        end
    end
    drawButton(text,font,nx,ny,nw,nh,btnColor,{1,1,1},drawColors.shading,drawColors.shading)
end