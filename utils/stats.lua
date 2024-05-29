require("love")
function loadStatistics()
    local obj = {}
    setIdentity()
    if love.filesystem.getInfo("stats.json") then --we have stats
        obj = json.decode(love.filesystem.read("stats.json"))
    else --we dont have stats
        love.filesystem.write("stats.json",json.encode(getDefaults()))
        obj = getDefaults()
    end
    return obj,#obj
end

function setIdentity()
    --identity: scp_cacapalavra
    --hardcoded! DO NOT CHANGE THIS SHIT MATE
    love.filesystem.setIdentity("scp_cacapalavra")
end

function getDefaults()
    local obj = {}
    obj[#obj+1] = {name="Melhor tempo",value="00:00"}
    obj[#obj+1] = {name="Tempo total",value="00:00"}
    obj[#obj+1] = {name="Melhor pontuação",value="0"}
    obj[#obj+1] = {name="Jogos jogados",value="0"}
    return obj
end

function updateStats()
    local time = getSeconds(gameScore.time)
    local bestTime = getSeconds(stats[1].value)
    if time<bestTime or stats[1].value=="00:00" then --update best time
        stats[1].value=gameScore.time
    end
    
    if gameScore.points>tonumber(stats[3].value) then --update best points
        stats[3].value=tostring(gameScore.points)
    end
    print()
    --update total time
    local totaltime = getSeconds(stats[2].value)
    local newtotaltime = totaltime+time
    print("time: ", time)
    print("recorded: ", totaltime)
    print("new time: ", newtotaltime)
    print("get formated?", getFormattedTime(newtotaltime))
    stats[2].value=getFormattedTime(newtotaltime)

    --update total games
    stats[4].value=tostring(tonumber(stats[4].value)+1)

end

function saveStats()
    love.filesystem.write("stats.json",json.encode(stats))
end