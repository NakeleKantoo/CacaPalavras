require("love")

PANIC = false
PANICMESSAGE = ""
PANICDT = 1

stats,numStats = loadStatistics()

settings,numSettings = loadSettings()

boardW = settings.size.possible[settings.size.value]
boardH = settings.size.possible[settings.size.value]
blockW = 35
blockH = 35
numWords = 10
interSpace = 0
difficulty = 0 --0=normal 1=inverse 2=more diagonals 3=even more diagonals
board = {}
palavras = {}
love.math.setRandomSeed(os.time())
rng = love.math.random
screenw,screenh = love.graphics.getDimensions()
font = 30
textfont = 25
boardfont = 30
clicked = 0
directionClick = false
destinyClick = 0
achadas = {}
lines = {}
currentColor = {1,0.9,0}
coins = 0
deltaTime = 0

pressed = false

gameState = {
    paused = false,
    inUI = {
        winMenu = false,
        newMenu = false,
        configMenu = false,
        statsMenu = false
    },
    mode = "normal", -- "normal" | "hardcore"
    won=false
}

gameScore = {
    points = 0,
    time = "00:00",
    thisCoins = 0
}

drawColors = {
    gameBack = {0.211, 0.09, 0.368},

    shading = {0.117, 0.0, 0.254, 0.65},
    back = {0.403, 0.227, 0.713},--{0.514, 0.459, 0.961},
    underline = {0.659, 0.435, 1},
    button = {0.501, 0.337, 0.643},
    buttonHighlight = {0.584, 0.454, 0.803},
    buttonPress = {0.294, 0.192, 0.509},
    text = {1,1,1},

    foundWord = {1, 0.627, 0.239}--{1.0, 0.321, 0.321}
}

particles = {} -- (text,color,posx,posy,ttl)

buttons = {
    {img=love.graphics.newImage("img/settings.png")},
    {img=love.graphics.newImage("img/new.png")},
    {img=love.graphics.newImage("img/stats.png")}
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
    local standard = 392 -- my phone's width
    screenw, screenh = love.graphics.getDimensions()
    local spacing = 30
    blockW=(screenw-spacing-(interSpace*boardW))/boardW
    blockH=blockW
    scale = blockH/1.5/boardfont
    scaleNormal = screenw/392
    font=font*0.8*scaleNormal
    textfont=textfont*0.8*scaleNormal
    boardfont=boardfont*scale
else
    love.window.setFullscreen(true)
    screenw, screenh = love.graphics.getDimensions()
end

font=love.graphics.newFont("fonts/SpaceMono-Regular.ttf",font)
textfont=love.graphics.newFont("fonts/SpaceMono-Regular.ttf",textfont)
boardfont=love.graphics.newFont("fonts/SpaceMono-Regular.ttf",boardfont)

settingsPage, settingsMaxPage, settingsMaxPerPage = 1,getMaxSettingsPage()

if love.filesystem.getInfo("version.scp") then
    local v = love.filesystem.read("version.scp")
    if v ~= VERSION then
        gameState.paused=true
        love.filesystem.remove("config.json")
        settings,numSettings = loadSettings()
        settingsPage, settingsMaxPage, settingsMaxPerPage = 1,getMaxSettingsPage()
        gameState.paused=false
        love.filesystem.write("version.scp",VERSION)
    end
else
    gameState.paused=true
    love.filesystem.remove("config.json")
    settings,numSettings = loadSettings()
    settingsPage, settingsMaxPage, settingsMaxPerPage = 1,getMaxSettingsPage()
    gameState.paused=false
    love.filesystem.write("version.scp",VERSION)
end