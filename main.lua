VERSION = "1.0"
require("utils.settings")
require("utils.vars")
require("utils.draw")
require("utils.utils")
require("utils.palavras")
require("utils.clickHandler")

function love.load()
    board = newBoard()
    --for i=1,#board do print(board[i]) end
end

function love.update(dt)
    if gameState.paused==false then deltaTime=deltaTime+dt end --dt only counts when in game
    --dt checking
    if deltaTime>=1 then
        gameScore.time=increaseSecond()
        deltaTime=deltaTime-1
    end
    updateParticles(dt)

    local mx, my = love.mouse.getPosition()
    if love.mouse.isDown(1) then
        local block = checkWhichBlock(mx,my)
        if block>0 then
            directionClick = checkDirection(clicked,block)
            destinyClick=block
        end
    else
        if clicked>0 then
            --check word
            local word = checkWord(clicked,destinyClick,directionClick)
            for i,v in ipairs(palavras) do
                if word==v then
                    local already = false
                    for k,w in ipairs(achadas) do
                        if word==w or invertWord(word)==w then already=true; break end
                    end
                    if already==false then
                        achadas[#achadas+1] = word
                        lines[#lines+1] = {origin = clicked, destiny = destinyClick, direction = directionClick, color = currentColor}
                        local points = (50*word:len())-(math.floor(getSeconds()/15)-math.floor(word:len()*0.75))
                        table.insert(particles,{text="+"..points,color={0,1,0},posx=mx,posy=my,ttl=1.5})
                        gameScore.points=gameScore.points+points
                    end
                elseif invertWord(word) == v then
                    local already = false
                    for k,w in ipairs(achadas) do
                        if word==w or invertWord(word)==w then already=true; break end
                    end
                    if already==false then
                        achadas[#achadas+1] = invertWord(word)
                        lines[#lines+1] = {origin = clicked, destiny = destinyClick, direction = directionClick, color = currentColor}
                        local points = math.floor((50/getSeconds())*10*word:len())
                        table.insert(particles,{text="+"..points,color={0,1,0},posx=mx,posy=my,ttl=1.5})
                        gameScore.points=gameScore.points+points
                    end
                end
            end

            clicked=0
        end
    end
    checkVictory()
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

        end
    else
        if gameState.inUI.configMenu then
            local btn = settingsCollision(x,y)
            if btn=="pressed" then
                
            end
        end
    end
end

