require("love")

boardW = 10
boardH = 10
blockW = 35
blockH = 35
numWords = 1
interSpace = 0
difficulty = 0 --0=normal 1=inverse 2=more diagonals
board = {}
palavras = {}
love.math.setRandomSeed(os.time())
rng = love.math.random
screenw,screenh = love.graphics.getDimensions()
font = 30
textfont = 25
clicked = 0
directionClick = false
destinyClick = 0
achadas = {}
lines = {}
currentColor = {1,0.9,0}
coins = 0
deltaTime = 0

gameState = {
    paused = false,
    inUI = {
        winMenu = false,
        newMenu = false,
        configMenu = false,
        storeMenu = false
    }
}

gameScore = {
    points = 0,
    time = "00:00"
}

drawColors = {
    gameBack = {0.211, 0.09, 0.368},

    shading = {0.117, 0.0, 0.254, 0.65},
    back = {0.403, 0.227, 0.713},--{0.514, 0.459, 0.961},
    underline = {0.659, 0.435, 1},
    button = {0.501, 0.337, 0.643},
    buttonHighlight = {0.584, 0.454, 0.803},
    buttonPress = {0.294, 0.192, 0.509},

    foundWord = {1, 0.627, 0.239}--{1.0, 0.321, 0.321}
}

particles = {} -- (text,color,posx,posy,ttl)

buttons = {
    {img=love.graphics.newImage("img/settings.png")},
    {img=love.graphics.newImage("img/new.png")},
    {img=love.graphics.newImage("img/market.png")}
}

settings,numSettings = loadSettings()


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
    scale = blockH/1.5/font
    font=font*scale
    textfont=textfont*scale
else
    love.window.setFullscreen(true)
    screenw, screenh = love.graphics.getDimensions()
end

font=love.graphics.newFont("fonts/SpaceMono-Regular.ttf",font)
textfont=love.graphics.newFont("fonts/SpaceMono-Regular.ttf",textfont)