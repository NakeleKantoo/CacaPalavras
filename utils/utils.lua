local alfabeto = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"}

function newBoard()
    local words = getRandomWords(5)
    palavras={words[1],words[2],words[3],words[4],words[5]} --render things
    local obj = {}
    local placing = false
    local wordPlaced = ""
    for i=1,100 do
        if placing then
            table.insert(obj,string.sub(wordPlaced,1,1))
            if #wordPlaced==1 then placing=false end
            if #wordPlaced>=2 then wordPlaced=string.sub(wordPlaced,2,#wordPlaced) end
        else
            table.insert(obj,alfabeto[rng(1,#alfabeto)])
        end
        if (i%10==0 or i==1) and #words>0 then
            placing = true
            wordPlaced = words[1]..""
            table.remove(words,1)
        end
    end
    return obj
end

