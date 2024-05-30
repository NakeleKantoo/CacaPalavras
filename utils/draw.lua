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
        love.graphics.printf(string.upper(board[i]),boardfont,x,y+((blockH-spacing*2)/2-boardfont:getHeight()/2-(blockH-spacing)/10),blockW,"center")
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
    --print(wowText)
    local maxW = math.min(textfont:getWidth(wowText)+20,screenw-50)
    local h = 0
    local tmp, many = textfont:getWrap(wowText,maxW)
    h=((h-10)+textfont:getHeight()+15)*#many

    local x = screenw/2-maxW/2
    local y = 15

    --draw shading
    love.graphics.setColor(drawColors.shading)
    love.graphics.rectangle('fill',x+5,y+5,maxW+5,h+5)

    --draw back
    love.graphics.setColor(drawColors.back)
    love.graphics.rectangle('fill',x,y,maxW+5,h+5)
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
    local widthScale = 1.2
    if checkMobile()==false then widthScale=2.5 end

    local w = screenw/widthScale
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
    printf("Configurações",font,x,y+15,w,"center",{1,1,1},drawColors.shading,3,drawColors.underline)

    y=y+font:getHeight()*2+textfont:getHeight()+5
    local min, max = settingsMaxPerPage*(settingsPage-1)+1,math.min(numSettings,settingsMaxPerPage*settingsPage)
    for i=min,max do
        v={}
        for k,vl in pairs(settings) do if i==vl.id then v=vl end end
        settingsOption(v,w-30,x+15,y)
        y=y+font:getHeight()*2+textfont:getHeight()+5
    end

    --draw page thing
    if settingsMaxPage>1 then
        local bw,bh = 30,30
        local spacing = 10
        local text = settingsPage.."/"..settingsMaxPage
        local textW = textfont:getWidth(text)
        local bx, by = screenw/2+w/2-(bw*2)-textW-(spacing*4),screenh/2+h/2-(spacing*2)-bh
        buttonWrapper("-",bx,by,bw,bh,function ()
            settingsPage=math.max(1,settingsPage-1)
        end)
        bx=bx+bw+spacing
        printf(text,textfont,bx,by,textW,"center",drawColors.text,drawColors.shading,3)
        bx=bx+textW+spacing
        buttonWrapper("+",bx,by,bw,bh,function ()
            settingsPage=math.min(settingsMaxPage,settingsPage+1)
        end)
    end
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
        --shading :)
        love.graphics.setColor(shading)
        love.graphics.rectangle("fill",nx+3,ny+6,w+6,5,2)
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

function settingsOption(settingTable,width,x,y)
    local text = settingTable.name
    local value = settingTable.value
    local fnFWR = nil
    local fnBCW = nil
    local argsFWR = nil
    local argsBCW = nil
    printf(text,font,x,y,width,"center",{1,1,1},drawColors.shading,2,drawColors.underline)
    y=y+font:getHeight()+18
    if settingTable.step then
        fnFWR = stepWrapper
        argsFWR = {settingTable.name,1}
        fnBCW = stepWrapper
        argsBCW = {settingTable.name,-1}
    else
        fnFWR = switchNext
        argsFWR = settingTable
        fnBCW = switchPrior
        argsBCW = settingTable
    end
    local size = math.max(font:getWidth("+"),font:getHeight())
    buttonWrapper("-",x,y,size,size,fnBCW,argsBCW)
    printf(value,textfont,x,y,width,"center",{1,1,1},drawColors.shading,2)
    buttonWrapper("+",x+width-size,y,size,size,fnFWR,argsFWR)
end

function buttonWrapper(text,nx,ny,nw,nh,fn,...)
    local btnColor = drawColors.button
    local mx,my=love.mouse.getPosition()
    if mx >= nx and mx <= nx+nw and my >= ny and my <= ny+nh then
        btnColor=drawColors.buttonHighlight
        if love.mouse.isDown(1) then
            btnColor=drawColors.buttonPress
            if pressed==false then fn(...); playMenu() end
            pressed=true
        end
    end
    drawButton(text,font,nx,ny,nw,nh,btnColor,{1,1,1},drawColors.shading,drawColors.shading)
end

function drawVictory()
    --grey out the background
    love.graphics.setColor(0,0,0,0.25)
    love.graphics.rectangle('fill',0,0,screenw,screenh)

    --draw the back of menu
    local widthScale = 1.2
    if checkMobile()==false then widthScale=2.5 end

    local heightScale = 2.5
    if checkMobile()==false then heightScale=3 end

    local w = screenw/widthScale
    local h = screenh/heightScale
    local x = screenw/2-w/2
    local y = screenh/2-h/2

    --shading
    love.graphics.setColor(drawColors.shading)
    love.graphics.rectangle("fill",x+15,y+15,w,h)

    --actual back
    love.graphics.setColor(drawColors.back)
    love.graphics.rectangle("fill",x,y,w,h)

    --text
    printf("Vitória!",font,x,y+15,w,"center",{1,1,1},drawColors.shading,3,drawColors.underline)
    x=x+5
    w=w-10
    y=y+font:getHeight()+15+15
    printf("Pontos:",font,x,y+15,w,"left",{1,1,1},drawColors.shading,3)
    printf(gameScore.points,font,x,y+15,w,"right",{1,1,1},drawColors.shading,3)
    y=y+font:getHeight()
    printf("Tempo:",font,x,y+15,w,"left",{1,1,1},drawColors.shading,3)
    printf(gameScore.time,font,x,y+15,w,"right",{1,1,1},drawColors.shading,3)
    y=y+font:getHeight()
    printf("Moedas:",font,x,y+15,w,"left",{1,1,1},drawColors.shading,3)
    printf(gameScore.thisCoins,font,x,y+15,w,"right",{1,1,1},drawColors.shading,3)
    
    --reset vars
    x=x-5
    w=w+10

    --button dimensions
    local btnW = math.max(w/20,font:getWidth("Novo Jogo")+20)
    local btnH = math.max(h/10,font:getHeight()+20)
    --button for new game
    x = screenw/2-btnW/2
    y = screenh/2+h/2-15-btnH
    buttonWrapper("Novo Jogo",x,y,btnW,btnH,newGame)
end

function drawTime()
    local androidFactor = 0.25
    if checkMobile() then androidFactor=0.15 end  
    local buttonHeight = 256*androidFactor -- Altura dos botões (ajuste conforme necessário)
    -- Calcula a posição y dos botões colados na parte inferior da tela
    local textHeight = textfont:getHeight()+15
    local y = screenh - buttonHeight - 20 - textHeight - 15
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", -150, y, textfont:getWidth(gameScore.time)+150+10, textHeight,10)
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf(gameScore.time,textfont,0,y+7.5,textfont:getWidth(gameScore.time)+5,"center")
end

function drawPoints()
    local androidFactor = 0.25
    if checkMobile() then androidFactor=0.15 end  
    local buttonHeight = 256*androidFactor -- Altura dos botões (ajuste conforme necessário)
    -- Calcula a posição y dos botões colados na parte inferior da tela
    local textHeight = textfont:getHeight()+15
    local y = screenh - buttonHeight - 20 - textHeight - 15

    local x = screenw-textfont:getWidth(gameScore.points)-20
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", x, y, 150, textHeight,10)
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf(gameScore.points,textfont,x+10,y+7.5,150,"left")
end

function drawParticles()
    for i=1,#particles do
        local particle = particles[i]
        love.graphics.setColor(particle.color)
        love.graphics.print(particle.text,textfont,particle.posx,particle.posy)
        --shadow
        love.graphics.setColor(particle.color[1]/1.5,particle.color[2]/1.5,particle.color[3]/1.5)
        love.graphics.print(particle.text,textfont,particle.posx+2,particle.posy+2)
    end
end

function drawStats()
    --grey out the background
    love.graphics.setColor(0,0,0,0.25)
    love.graphics.rectangle('fill',0,0,screenw,screenh)

    --draw the back of menu
    local widthScale = 1.2
    if checkMobile()==false then widthScale=2.6 end

    local heightScale = 2.3
    if checkMobile()==false then heightScale=3 end

    local w = screenw/widthScale
    local h = screenh/heightScale
    local x = screenw/2-w/2
    local y = screenh/2-h/2

    --shading
    love.graphics.setColor(drawColors.shading)
    love.graphics.rectangle("fill",x+15,y+15,w,h)

    --actual back
    love.graphics.setColor(drawColors.back)
    love.graphics.rectangle("fill",x,y,w,h)

    --text
    printf("Estatísticas:",font,x,y+15,w,"center",{1,1,1},drawColors.shading,3,drawColors.underline)
    x=x+5
    w=w-10
    y=y+font:getHeight()+15+15
    for i=1,#stats do
        printf(stats[i].name,textfont,x,y+15,w,"left",{1,1,1},drawColors.shading,3)
        printf(stats[i].value,textfont,x,y+15,w,"right",{1,1,1},drawColors.shading,3)
        y=y+font:getHeight()
    end
    
    
    --reset vars
    x=x-5
    w=w+10

    --button dimensions
    local btnW = math.max(w/20,font:getWidth("Voltar")+20)
    local btnH = math.max(h/10,font:getHeight()+20)
    --button for new game
    x = screenw/2-btnW/2
    y = screenh/2+h/2-15-btnH
    buttonWrapper("Voltar",x,y,btnW,btnH,function ()
        gameState.inUI.statsMenu=false;gameState.paused=false
    end)
end


function drawNewGame()
    --grey out the background
    love.graphics.setColor(0,0,0,0.25)
    love.graphics.rectangle('fill',0,0,screenw,screenh)

    --draw the back of menu
    local widthScale = 1.2
    if checkMobile()==false then widthScale=3 end

    local heightScale = 2
    if checkMobile()==false then heightScale=3 end

    local w = screenw/widthScale
    local h = screenh/heightScale
    local x = screenw/2-w/2
    local y = screenh/2-h/2

    --shading
    love.graphics.setColor(drawColors.shading)
    love.graphics.rectangle("fill",x+15,y+15,w,h)

    --actual back
    love.graphics.setColor(drawColors.back)
    love.graphics.rectangle("fill",x,y,w,h)

    --text
    printf("Novo Jogo",font,x,y+15,w,"center",{1,1,1},drawColors.shading,3,drawColors.underline)
    x=x+5
    w=w-10
    y=y+font:getHeight()+15
    local mode = "Normal: Jogo normal, Tempo ilimitado!"
    if gameState.mode=="hardcore" then mode = "Hardcore: Tempo limitado, mais dificil, mais pontos!" end
    if gameState.mode=="tranquilo" then mode = "Tranquilo: Sem tempo, sem pontos, para relaxar" end
    local btnW = math.max(w/20,textfont:getWidth(">")+20)
    local btnH = math.max(h/10,textfont:getHeight()+5)
    printf("Modo de jogo: "..mode,textfont,x,y+5,w-btnW*2-15,"left",{1,1,1},drawColors.shading,3)
    x = screenw/2+w/2-btnW*2-15
    buttonWrapper("<",x,y,btnW,btnH,changemode,false)
    x=x+btnW+5
    buttonWrapper(">",x,y,btnW,btnH,changemode,true)

    local txt = "Modo de jogo: "..mode
    local maxW = math.min(textfont:getWidth(txt)+20,screenw-50)
    local nh = 0
    local tmp, many = textfont:getWrap(txt,w-btnW*2-15) --god damn.
    print(#many)
    nh=nh+((textfont:getHeight())*#many)
    y=y+nh


    x=screenw/2-(w+10)/2+5
    printf("Dificuldade: "..settings.hardSetting.value,textfont,x,y+15,w-btnW*2-15,"left",{1,1,1},drawColors.shading,3)
    x = screenw/2+w/2-btnW*2-15
    buttonWrapper("<",x,y,btnW,btnH,switchPrior,settings.hardSetting)
    x=x+btnW+5
    buttonWrapper(">",x,y,btnW,btnH,switchNext,settings.hardSetting)
    y=y+font:getHeight()
    
    
    --reset vars
    x=x-5
    w=w+10

    --button dimensions
    local btnW = math.max(w/20,font:getWidth("Novo Jogo")+20)
    local btnH = math.max(h/10,font:getHeight()+20)
    --button for new game
    x = screenw/2-btnW/2
    y = screenh/2+h/2-15-btnH
    buttonWrapper("Novo Jogo",x,y,btnW,btnH,function ()
        newGame());gameState.inUI.newMenu=false;gameState.paused=false
    end)
end

function drawPanic()
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill",0,0,screenw,screenh)
    love.graphics.setColor(1,1,1)
    local y = screenh/2-font:getHeight()*3-5
    love.graphics.printf("ERRO",font,0,y,screenw,"center")
    y=y+font:getHeight()+5
    love.graphics.printf(PANICMESSAGE,font,0,y,screenw,"center")
    if PANICDT<0 then
        y=screenh-font:getHeight()-15
        local w,wrap = font:getWrap("Pressione em qualquer lugar para voltar.",screenw)
        y=y-font:getHeight()*(#wrap-1)
        love.graphics.printf("Pressione em qualquer lugar para voltar.",font,0,y,screenw,"center")
    end
end