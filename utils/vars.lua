require("love")

boardW = 7
boardH = 7
blockW = 35
blockH = 35
numWords = 3
interSpace = 2
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
currentColor = {1,0.9,0}

gameState = {
    paused = false,
    inUI = {
        winMenu = false,
        newMenu = false,
        configMenu = false,
        storeMenu = false
    }
}

buttons = {
    {img=love.graphics.newImage("img/settings.png")},
    {img=love.graphics.newImage("img/new.png")},
    {img=love.graphics.newImage("img/market.png")}
}


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
    local spacing = 30
    blockW=(screenw-spacing-(interSpace*boardW))/boardW
    blockH=blockW
    scale = (boardW*(blockW+interSpace))/(screenw+spacing)
    font=font*scale
    textfont=textfont*scale
end

font=love.graphics.newFont(font)
textfont=love.graphics.newFont(textfont)