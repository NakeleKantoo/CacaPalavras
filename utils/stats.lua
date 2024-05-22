require("love")
function loadStatistics()
    love.filesystem.exists("stats.json")
end

function setIdentity()
    --identity: scp_cacapalavra
    --hardcoded! DO NOT CHANGE THIS SHIT MATE
    love.filesystem.setIdentity("scp_cacapalavra")
end