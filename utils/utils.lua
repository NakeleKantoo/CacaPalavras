local alfabeto = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"}

local diffOrientations = {}
table.insert(diffOrientations,0,{"h","h","h","v","v","d","sd"})
table.insert(diffOrientations,1,{"h","h","v","v","d","d","sd"})
table.insert(diffOrientations,2,{"h","h","v","v","v","d","d","d","sd","sd"})

function newBoard()
    ::retry:: --dont get stuck with hopeless placements (unlucky ahh random shit)
    local words = getRandomWords(numWords)
    palavras={}
    for i=1,#words do
        palavras[#palavras+1] = words[i]
    end
    local obj = {}
    local placing = false
    local wordPlaced = ""
    local orientations = diffOrientations[difficulty]--{"h","h","h","v","v","d"} --horizontal, vertical, diagonal
    for i=1,#words do
        local direction = orientations[rng(1,#orientations)]
        local word = words[i]
        local found=false
        local tries = 0
        local maxTries = 50
        if direction=="h" then
            --find a place for the word
            local x = 0
            local y = 0
            if rng(1,100)<difficulty*10 then word=invertWord(word) end
            while found==false do
                x = rng(1,boardW-#word-1)
                y = rng(1,boardH-1)
                --check if the place is occupied :)
                for i=1,#word do
                    if obj[x+i-1+(y*boardW)] then if obj[x+i-1+(y*boardW)]~=string.sub(word,i,i) then break end end
                    if (obj[x+i-1+(y*boardW)]==nil or obj[x+i-1+(y*boardW)]==string.sub(word,i,i)) and i==#word then found=true end 
                end
                tries = tries +1
                if tries>maxTries then goto retry end
            end
            --ok now place the word
            for i=1,#word do
                obj[x+i-1+(y*boardW)]=string.sub(word,i,i)
            end
        elseif direction=="v" then
            --find a place for the word
            local x = 0
            local y = 0
            if rng(1,100)<difficulty*10 then word=invertWord(word) end
            while found==false do
                x = rng(1,boardW-1)
                y = rng(1,boardH-#word-1)
                --check if the place is occupied :)
                for i=1,#word do
                    if obj[x+((y+i-1)*boardW)] then if obj[x+((y+i-1)*boardW)]~=string.sub(word,i,i) then break end end
                    if (obj[x+((y+i-1)*boardW)]==nil or obj[x+((y+i-1)*boardW)]==string.sub(word,i,i)) and i==#word then found=true end 
                end
                tries = tries +1
                if tries>maxTries then goto retry end
            end
            --ok now place the word
            for i=1,#word do
                obj[x+((y+i-1)*boardW)]=string.sub(word,i,i)
            end
        elseif direction=="d" then
            --find a place for the word
            local x = 0
            local y = 0
            if rng(1,100)<difficulty*5 then word=invertWord(word) end
            while found==false do
                x = rng(1,boardW-#word-1)
                y = rng(1,boardH-#word-1)
                --check if the place is occupied :)
                for i=1,#word do
                    if obj[x+i-1+((y+i-1)*boardW)] then if obj[x+i-1+((y+i-1)*boardW)]~=string.sub(word,i,i) then break end end
                    if (obj[x+i-1+((y+i-1)*boardW)]==nil or obj[x+i-1+((y+i-1)*boardW)]==string.sub(word,i,i)) and i==#word then found=true end 
                end
                tries = tries +1
                if tries>maxTries then goto retry end
            end
            --ok now place the word
            for i=1,#word do
                obj[x+i-1+((y+i-1)*boardW)]=string.sub(word,i,i)
            end
        elseif direction=="sd" then
            --find a place for the word
            local x = 0
            local y = 0
            if rng(1,100)<95-difficulty*5 then word=invertWord(word) end
            while found==false do
                x = rng(#word+1,boardW)
                y = rng(1,boardH-#word-1)
                --check if the place is occupied :)
                for i=1,#word do
                    if obj[x-i+1+((y+i-1)*boardW)] then if obj[x-i+1+((y+i-1)*boardW)]~=string.sub(word,i,i) then break end end
                    if (obj[x-i+1+((y+i-1)*boardW)]==nil or obj[x-i+1+((y+i-1)*boardW)]==string.sub(word,i,i)) and i==#word then found=true end 
                end
                tries = tries +1
                if tries>maxTries then goto retry end
            end
            --ok now place the word
            for i=1,#word do
                obj[x-i+1+((y+i-1)*boardW)]=string.sub(word,i,i)
            end
        end
    end

    for i=1,boardW*boardH do
        if obj[i] then
        else
            obj[i]=alfabeto[rng(1,#alfabeto)]
        end
    end
    return obj
end

function checkVictory()
    if #achadas==#palavras then
        numWords=numWords+1
        boardW=boardW+1
        boardH=boardH+1
        board = newBoard()
        achadas={}
        lines={}
        if checkMobile() then
            screenw, screenh = love.graphics.getDimensions()
            local spacing = 30
            blockW=(screenw-spacing-(interSpace*boardW))/boardW
            blockH=blockW
            scale = (boardW*(blockW+interSpace))/(screenw+spacing)
            font=love.graphics.newFont(font:getHeight()*scale)
            textfont=love.graphics.newFont(textfont:getHeight()*scale)
        end
    end
end

function invertWord(word)
    local obj = ""
    for i=1,#word do
        obj=obj..string.sub(word,#word-i+1,#word-i+1)
    end
    return obj
end

