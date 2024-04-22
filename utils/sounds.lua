sfx = {
    menu = love.sound.newSoundData("sfx/menu.mp3"),
    found = love.sound.newSoundData("sfx/found.mp3"),
    victory = love.sound.newSoundData("sfx/victory.mp3")
}
sources = {}

function playFound()
    sources[#sources+1] = love.audio.newSource(sfx.found)
    love.audio.play(sources[#sources])
end

function playVictory()
    sources[#sources+1] = love.audio.newSource(sfx.victory)
    love.audio.play(sources[#sources])
end

function playMenu()
    sources[#sources+1] = love.audio.newSource(sfx.menu)
    love.audio.play(sources[#sources])
end

function changeVolume()
    love.audio.setVolume(settings.volume.value/100)
end