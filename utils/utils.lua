local alfabeto = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"}

local diffOrientations = {}
table.insert(diffOrientations,0,{"h","h","h","v","v","d","sd"})
table.insert(diffOrientations,1,{"h","h","v","v","d","d","sd"})
table.insert(diffOrientations,2,{"h","h","v","v","v","d","d","d","sd","sd"})
table.insert(diffOrientations,3,{"h","h","v","v","v","d","d","d","sd","sd","sd"})

function newBoard()
    ::retry:: --dont get stuck with hopeless placements (unlucky ahh random shit)
    local words = getRandomWords(settings.numWords.value)
    palavras={}
    for i=1,#words do
        palavras[#palavras+1] = words[i]
    end
    local obj = {}
    local placing = false
    local wordPlaced = ""
    local orientations = diffOrientations[difficulty]--{"h","h","h","v","v","d"} --horizontal, vertical, diagonal
    for i=1,#words do
        local direction = orientations[rng(1,#orientations)]
        local word = words[i]
        local found=false
        local tries = 0
        local maxTries = 50
        if direction=="h" then
            --find a place for the word
            local x = 0
            local y = 0
            if rng(1,100)<difficulty*10 then word=invertWord(word) end
            while found==false do
                x = rng(1,boardW-#word-1)
                y = rng(1,boardH-1)
                --check if the place is occupied :)
                for i=1,#word do
                    if obj[x+i-1+(y*boardW)] then if obj[x+i-1+(y*boardW)]~=string.sub(word,i,i) then break end end
                    if (obj[x+i-1+(y*boardW)]==nil or obj[x+i-1+(y*boardW)]==string.sub(word,i,i)) and i==#word then found=true end 
                end
                tries = tries +1
                if tries>maxTries then goto retry end
            end
            --ok now place the word
            for i=1,#word do
                obj[x+i-1+(y*boardW)]=string.sub(word,i,i)
            end
        elseif direction=="v" then
            --find a place for the word
            local x = 0
            local y = 0
            if rng(1,100)<difficulty*10 then word=invertWord(word) end
            while found==false do
                x = rng(1,boardW-1)
                y = rng(1,boardH-#word-1)
                --check if the place is occupied :)
                for i=1,#word do
                    if obj[x+((y+i-1)*boardW)] then if obj[x+((y+i-1)*boardW)]~=string.sub(word,i,i) then break end end
                    if (obj[x+((y+i-1)*boardW)]==nil or obj[x+((y+i-1)*boardW)]==string.sub(word,i,i)) and i==#word then found=true end 
                end
                tries = tries +1
                if tries>maxTries then goto retry end
            end
            --ok now place the word
            for i=1,#word do
                obj[x+((y+i-1)*boardW)]=string.sub(word,i,i)
            end
        elseif direction=="d" then
            --find a place for the word
            local x = 0
            local y = 0
            if rng(1,100)<difficulty*5 then word=invertWord(word) end
            while found==false do
                x = rng(1,boardW-#word-1)
                y = rng(1,boardH-#word-1)
                --check if the place is occupied :)
                for i=1,#word do
                    if obj[x+i-1+((y+i-1)*boardW)] then if obj[x+i-1+((y+i-1)*boardW)]~=string.sub(word,i,i) then break end end
                    if (obj[x+i-1+((y+i-1)*boardW)]==nil or obj[x+i-1+((y+i-1)*boardW)]==string.sub(word,i,i)) and i==#word then found=true end 
                end
                tries = tries +1
                if tries>maxTries then goto retry end
            end
            --ok now place the word
            for i=1,#word do
                obj[x+i-1+((y+i-1)*boardW)]=string.sub(word,i,i)
            end
        elseif direction=="sd" then
            --find a place for the word
            local x = 0
            local y = 0
            if rng(1,100)<95-difficulty*5 then word=invertWord(word) end
            while found==false do
                x = rng(#word+1,boardW)
                y = rng(1,boardH-#word-1)
                --check if the place is occupied :)
                for i=1,#word do
                    if obj[x-i+1+((y+i-1)*boardW)] then if obj[x-i+1+((y+i-1)*boardW)]~=string.sub(word,i,i) then break end end
                    if (obj[x-i+1+((y+i-1)*boardW)]==nil or obj[x-i+1+((y+i-1)*boardW)]==string.sub(word,i,i)) and i==#word then found=true end 
                end
                tries = tries +1
                if tries>maxTries then goto retry end
            end
            --ok now place the word
            for i=1,#word do
                obj[x-i+1+((y+i-1)*boardW)]=string.sub(word,i,i)
            end
        end
    end

    for i=1,boardW*boardH do
        if obj[i] then
        else
            obj[i]=alfabeto[rng(1,#alfabeto)]
        end
    end
    return obj
end

function checkVictory()
    if #achadas==#palavras then
        --newGame(0,0)
        gameState.paused=true
        gameState.inUI.winMenu=true
        updateStats()
        playVictory()
    end
end

function invertWord(word)
    local obj = ""
    for i=1,#word do
        obj=obj..string.sub(word,#word-i+1,#word-i+1)
    end
    return obj
end

function newGame(dw,ds)
    resetBoard(dw,ds)
    gameState.paused=false
    gameState.inUI.winMenu=false
    gameState.inUI.configMenu=false
    gameState.inUI.storeMenu=false
    particles={}
    adjustGameScore()
end

function resetBoard(dw,ds)
    numWords=settings.numWords.value
    boardW=boardW+ds
    boardH=boardH+ds
    board = newBoard()
    achadas={}
    lines={}
    gameScore.points=0
    gameScore.time="00:00"
    if checkMobile() then
        screenw, screenh = love.graphics.getDimensions()
        local spacing = 30
        blockW=(screenw-spacing-(interSpace*boardW))/boardW
        blockH=blockW
        scale = blockH/1.5/boardfont:getHeight()
        boardfont=love.graphics.newFont("fonts/SpaceMono-Regular.ttf",boardfont:getHeight()*scale)
        --textfont=love.graphics.newFont("fonts/SpaceMono-Regular.ttf",textfont:getHeight()*scale)
    end
end

function generateColor()
    ::tryagain:: --until get right
    local r,g,b = rng(1,100)/100,rng(1,100)/100,rng(1,100)/100,rng(25,45)/100
    if r+g+b>2 or r+g+b<0.5 then goto tryagain end
    return {r,g,b,0.45}
end

function increaseSecond()
    local time = split(gameScore.time,":")
    local secs = tonumber(time[2])
    local mins = tonumber(time[1])
    secs=secs+1
    if secs>=60 then secs=secs-60;mins=mins+1 end
    if secs<10 then secs="0"..tostring(secs) end
    if mins<10 then mins="0"..tostring(mins) end
    return mins..":"..secs
end

function getSeconds(time)
    local time = split(time,":")
    local secs = tonumber(time[2])
    local mins = tonumber(time[1])
    return mins*60+secs
end

function getFormattedTime(timeGiven)
    local secs = timeGiven
    local mins = 0
    while secs>=60 do
        secs=secs-60
        mins=mins+1
    end
    if secs<10 then secs="0"..tostring(secs) end
    if mins<10 then mins="0"..tostring(mins) end
    return mins..":"..secs
end

function split(str, sep)
    local result = {}
    local regex = ("([^%s]+)"):format(sep)
    for each in str:gmatch(regex) do
       table.insert(result, each)
    end
    return result
end

function updateParticles(dt)
    for i=1,#particles do
        local particle = particles[i]
        if particle.ttl<=0 then
            table.remove(particles,i)
            return false
        else
            particle.ttl=particle.ttl-dt
            particle.posy=particle.posy-50*dt
        end
    end
end

function foundWord(word)
    local mx, my = love.mouse.getPosition()
    achadas[#achadas+1] = word
    lines[#lines+1] = {origin = clicked, destiny = destinyClick, direction = directionClick, color = currentColor}
    local points = math.floor((50*word:len())-(math.floor(getSeconds(gameScore.time)/15)-math.floor(word:len()*0.75)))
    table.insert(particles,{text="+"..points,color={0,1,0},posx=mx,posy=my,ttl=1.5})
    gameScore.points=gameScore.points+points
    gameScore.thisCoins=math.max(15,math.floor(gameScore.points/500*(difficulty+1)))
    playFound()
end

function isThisWordFound(word)
    for k,w in ipairs(achadas) do
        if word==w or invertWord(word)==w then return true end
    end
    return false
end

function adjustGameScore() --add stats later
    gameScore.points=0
    coins = coins+gameScore.thisCoins
    gameScore.time="00:00"
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