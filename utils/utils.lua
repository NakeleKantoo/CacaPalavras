local alfabeto = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"}

function newBoard()
    local words = getRandomWords(5)
    palavras={words[1],words[2],words[3],words[4],words[5]} --render things
    local obj = {}
    local placing = false
    local wordPlaced = ""
    local orientations = {"h","v","d"} --horizontal, vertical, diagonal
    ::retry:: --dont get stuck with hopeless placements (unlucky ahh random shit)
    for i=1,#words do
        local direction = orientations[rng(1,#orientations)]
        local word = words[i]
        local found=false
        local tries = 0
        local maxTries = 50
        if direction=="h" then
            --find a place for the word
            local x = rng(1,boardW-#word)
            local y = rng(1,boardH)
            while found==false do
                x = rng(1,boardW-#word-1)
                y = rng(1,boardH-1)
                --check if the place is occupied :)
                for i=1,#word do
                    if obj[x+i-1+(y*boardW)] then break end
                    if obj[x+i-1+(y*boardW)]==nil and i==#word then found=true end 
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
            local x = rng(1,boardW-1)
            local y = rng(1,boardH-#word-1)
            while found==false do
                x = rng(1,boardW-1)
                y = rng(1,boardH-#word-1)
                --check if the place is occupied :)
                for i=1,#word do
                    if obj[x+((y+i-1)*boardW)] then break end
                    if obj[x+((y+i-1)*boardW)]==nil and i==#word then found=true end 
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
            local x = rng(1,boardW-1)
            local y = rng(1,boardH-#word-1)
            while found==false do
                x = rng(1,boardW-#word-1)
                y = rng(1,boardH-#word-1)
                --check if the place is occupied :)
                for i=1,#word do
                    if obj[x+i-1+((y+i-1)*boardW)] then break end
                    if obj[x+i-1+((y+i-1)*boardW)]==nil and i==#word then found=true end 
                end
                tries = tries +1
                if tries>maxTries then goto retry end
            end
            --ok now place the word
            for i=1,#word do
                obj[x+i-1+((y+i-1)*boardW)]=string.sub(word,i,i)
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

