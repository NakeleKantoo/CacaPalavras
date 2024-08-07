VERSION = "1.1" --bump version
require("utils.json")
require("utils.stats")
require("utils.settings")
require("utils.vars")
require("utils.draw")
require("utils.utils")
require("utils.palavras")
require("utils.clickHandler")
require("utils.sounds")

function love.load()
    board = newBoard()
    changeVolume()
    --for i=1,#board do print(board[i]) end
    start = love.timer.getTime()
    timer = 1
    current = 0
end

function love.update(dt)
    if PANIC then PANICDT=PANICDT-dt end
    if gameState.paused==false then current=love.timer.getTime()-start end --dt only counts when in game
    --dt checking
    if current>timer and focused then
        gameScore.time=increaseSecond()
        current=0
        start = love.timer.getTime()
        saveStats()
        saveSettings()
    end
    updateParticles(dt)
    if gameState.paused==false then
        if love.mouse.isDown(1) then
            local mx, my = love.mouse.getPosition()
            local block = checkWhichBlock(mx,my)
            if block>0 then
                directionClick = checkDirection(clicked,block)
                destinyClick=block
            end
        else
            pressed=false
            if clicked>0 then
                --check word
                local word = checkWord(clicked,destinyClick,directionClick)
                for i,v in ipairs(palavras) do
                    if word==v then
                        local already = isThisWordFound(word)
                        if already==false then
                            foundWord(word)
                        end
                    elseif invertWord(word) == v then
                        local already = isThisWordFound(word)                    
                        if already==false then
                            foundWord(invertWord(word))
                        end
                    end
                end
                clicked=0
            end
        end
        if gameState.won==false then checkVictory() end
    else
        if love.mouse.isDown(1)==false then
            pressed=false
        end
    end
end

function love.draw()
    if PANIC then drawPanic(); return true end

    drawBackground()
    drawBoard()
    drawWords()
    if clicked>0 then
        drawLine()
    end
    drawFoundLines()
    drawDock()
    drawTime()
    if gameState.mode=="normal" then
        drawPoints()
    end
    if gameState.mode~="tranquilo" then
        drawParticles()
    end
    

    --UI drawings
    if gameState.inUI.configMenu then drawSettings() end
    if gameState.inUI.winMenu then drawVictory() end
    if gameState.inUI.statsMenu then drawStats() end
    if gameState.inUI.newMenu then drawNewGame() end
end

function love.mousepressed(x,y)
    if PANIC and PANICDT<0 then PANIC=false end
    local block = 0
    if gameState.paused==false then block = checkWhichBlock(x,y) end
    if block>0 then
        clicked=block
        currentColor=generateColor()
    elseif checkForUIs()==false then
        local btn = checkButtons(x,y)
        if btn==1 then -- settings
            gameState.lastPauseState = gameState.paused
            gameState.paused=true
            gameState.inUI.configMenu=true
        elseif btn==2 then -- new
            gameState.lastPauseState = gameState.paused
            gameState.paused=true
            gameState.inUI.newMenu=true
            --newGame(0,0)
        elseif btn==3 then -- store (fuck)
            gameState.lastPauseState = gameState.paused
            gameState.paused=true
            gameState.inUI.statsMenu=true
        end
    else
        if gameState.inUI.configMenu then
            local btn = settingsCollision(x,y)
            if btn=="pressed" then
            elseif btn=="outside" then
                gameState.paused=gameState.lastPauseState
                gameState.inUI.configMenu=false
            end
        end
        if gameState.inUI.winMenu then
            local btn = winCollision(x,y)
            if btn=="outside" then
                gameState.inUI.winMenu=false
            end
        end
        if gameState.inUI.statsMenu then
            local btn = statsCollision(x,y)
            if btn=="outside" then
                gameState.inUI.statsMenu=false
                gameState.paused=gameState.lastPauseState
            end
        end
        if gameState.inUI.newMenu then
            local btn = newCollision(x,y)
            if btn=="outside" then
                gameState.inUI.newMenu=false
                gameState.paused=gameState.lastPauseState
            end
        end
    end
end

function love.focus(f)
    focused=f
end


