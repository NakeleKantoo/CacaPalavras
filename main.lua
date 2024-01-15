VERSION = "1.0"
require("utils.vars")
require("utils.draw")
require("utils.utils")
require("utils.palavras")

function love.load()
    board = newBoard()
    --for i=1,#board do print(board[i]) end
end

function love.update(dt)
end

function love.draw()
    drawBackground()
    drawBoard()
    drawWords()
end

