VERSION = "1.0"
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
    if love.mouse.isDown(1) then
        local mx, my = love.mouse.getPosition()
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
                        if word==w then already=true; break end
                    end
                    if already==false then
                        achadas[#achadas+1] = word
                        lines[#lines+1] = {origin = clicked, destiny = destinyClick, direction = directionClick, color = currentColor}
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
end

function love.mousepressed(x,y)
    local block = checkWhichBlock(x,y)
    if block>0 then
        clicked=block
        currentColor={rng(1,100)/100,rng(1,100)/100,rng(1,100)/100,rng(25,45)/100}
    end
end

