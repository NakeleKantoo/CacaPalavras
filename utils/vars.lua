require("love")

boardW = 10
boardH = 10
blockW = 35
blockH = 35
numWords = 5
board = {}
palavras = {}
love.math.setRandomSeed(os.time())
rng = love.math.random
screenw,screenh = love.graphics.getDimensions()
font = 30
textfont = 20
clicked = 0
directionClick = false
destinyClick = 0
achadas = {}
lines = {}

system = love.system.getOS()

function checkMobile()
    if system=="Android" then return true end
    return false
end

if checkMobile() then
    local wait=true
    while wait do
        love.window.maximize()
        love.window.setMode(1,2)
        local tx, ty = love.graphics.getDimensions()
        if ty>tx then wait=false end
    end
    screenw, screenh = love.graphics.getDimensions()
    scale = 0.8
    blockW=blockW*scale
    blockH=blockH*scale
    font=font*scale
    textfont=textfont*scale
end

font=love.graphics.newFont(font)
textfont=love.graphics.newFont(textfont)