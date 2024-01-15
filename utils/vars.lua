require("love")

boardW = 10
boardH = 10
blockW = 35
blockH = 35
board = {}
palavras = {}
love.math.setRandomSeed(os.time())
rng = love.math.random
screenw,screenh = love.graphics.getDimensions()
font = love.graphics.newFont(30)
textfont = love.graphics.newFont(25)