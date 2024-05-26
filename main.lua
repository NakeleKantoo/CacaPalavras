VERSION = "1.0"
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
end

function love.update(dt)
    if gameState.paused==false then deltaTime=deltaTime+dt end --dt only counts when in game
    --dt checking
    if deltaTime>=1 then
        gameScore.time=increaseSecond()
        deltaTime=deltaTime-1
        saveStats()
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
        checkVictory()
    else
        if love.mouse.isDown(1)==false then
            pressed=false
        end
    end
end

function love.draw()
    drawBackground()
    drawBoard()
    drawWords()
    if clicked>0 then
        drawLine()
    end
    drawFoundLines()
    drawDock()
    drawTime()
    drawParticles()
    

    --UI drawings
    if gameState.inUI.configMenu then drawSettings() end
    if gameState.inUI.winMenu then drawVictory() end
    if gameState.inUI.statsMenu then drawStats() end
end

function love.mousepressed(x,y)
    
    local block = checkWhichBlock(x,y)
    if block>0 then
        clicked=block
        currentColor=generateColor()
    elseif gameState.paused==false then
        local btn = checkButtons(x,y)
        if btn==1 then -- settings
            gameState.paused=true
            gameState.inUI.configMenu=true
        elseif btn==2 then -- new
            newGame(0,0)
        elseif btn==3 then -- store (fuck)
            gameState.paused=true
            gameState.inUI.statsMenu=true
        end
    else
        if gameState.inUI.configMenu then
            local btn = settingsCollision(x,y)
            if btn=="pressed" then
            elseif btn=="outside" then
                gameState.paused=false
                gameState.inUI.configMenu=false
            end
        end
        if gameState.inUI.winMenu then
            local btn = winCollision(x,y)
            gameState.inUI.winMenu=false
        end
    end
end


