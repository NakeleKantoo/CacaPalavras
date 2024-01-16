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
    else
        if clicked>0 then
            clicked=0
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
end

function love.mousepressed(x,y)
    local block = checkWhichBlock(x,y)
    if block>0 then
        clicked=block
    end
end

