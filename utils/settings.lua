function loadSettings()
    local obj = {
        hardSetting = {id=1,value="Médio",name="Dificuldade",possible=loadPossibleDifficulties()},
        volume = {id=2,value=100,name="Volume",min=0,max=100,step=5},
        theme = {id=3,value="Roxo",name="Tema",possible=loadPossibleThemes()},
        size = {id=4,value="10x10",name="Tamanho",possible=loadPossibleSizes()}
    }
    return obj,4
end

function loadPossibleDifficulties()
    local obj = {
        ["Fácil"] = 0,
        ["Médio"] = 1,
        ["Difícil"] = 2,
        ["Desafiador"] = 3,
        keys = {"Fácil","Médio","Difícil","Desafiador"}
    }
    return obj
end

function loadPossibleSizes()
    local obj = {
        ["10x10"] = 10,
        ["15x15"] = 15,
        ["20x20"] = 20,
        ["25x25"] = 25,
        keys = {"10x10","15x15","20x20","25x25"}
    }
    return obj
end

function loadPossibleThemes()
    local obj = {
        ["Roxo"] = {
            gameBack = {0.211, 0.09, 0.368},
            shading = {0.117, 0.0, 0.254, 0.65},
            back = {0.403, 0.227, 0.713},
            underline = {0.659, 0.435, 1},
            button = {0.501, 0.337, 0.643},
            buttonHighlight = {0.584, 0.454, 0.803},
            buttonPress = {0.294, 0.192, 0.509},
            foundWord = {1, 0.627, 0.239}
        },
        ["Azul"] = { --TODO
            gameBack = {0.211, 0.09, 0.368},
            shading = {0.117, 0.0, 0.254, 0.65},
            back = {0.403, 0.227, 0.713},
            underline = {0.659, 0.435, 1},
            button = {0.501, 0.337, 0.643},
            buttonHighlight = {0.584, 0.454, 0.803},
            buttonPress = {0.294, 0.192, 0.509},
            foundWord = {1, 0.627, 0.239}
        },
        ["Vermelho"] = { --TODO
            gameBack = {0.211, 0.09, 0.368},
            shading = {0.117, 0.0, 0.254, 0.65},
            back = {0.403, 0.227, 0.713},
            underline = {0.659, 0.435, 1},
            button = {0.501, 0.337, 0.643},
            buttonHighlight = {0.584, 0.454, 0.803},
            buttonPress = {0.294, 0.192, 0.509},
            foundWord = {1, 0.627, 0.239}
        },
        ["Verde"] = { --TODO
            gameBack = {0.211, 0.09, 0.368},
            shading = {0.117, 0.0, 0.254, 0.65},
            back = {0.403, 0.227, 0.713},
            underline = {0.659, 0.435, 1},
            button = {0.501, 0.337, 0.643},
            buttonHighlight = {0.584, 0.454, 0.803},
            buttonPress = {0.294, 0.192, 0.509},
            foundWord = {1, 0.627, 0.239}
        },
        ["Escuro"] = {
            gameBack = {0.15,0.15,0.15},
            shading = {0.1,0.1,0.1, 0.65},
            back = {0.2,0.2,0.2},
            underline = {1,1,1},
            button = {0.6,0.6,0.6},
            buttonHighlight = {0.8,0.8,0.8},
            buttonPress = {0.55,0.55,0.55},
            foundWord = {1, 0.627, 0.239}
        },
        ["Laranja"] = { --TODO
            gameBack = {0.211, 0.09, 0.368},
            shading = {0.117, 0.0, 0.254, 0.65},
            back = {0.403, 0.227, 0.713},
            underline = {0.659, 0.435, 1},
            button = {0.501, 0.337, 0.643},
            buttonHighlight = {0.584, 0.454, 0.803},
            buttonPress = {0.294, 0.192, 0.509},
            foundWord = {1, 0.627, 0.239}
        },
        keys = {"Vermelho","Verde","Azul","Roxo","Laranja","Escuro"}
    }
    return obj
end

function switchNext(tab)
    local found = false
    for i,v in ipairs(tab.possible.keys) do
        local k=v
        if found then
            local nextKey = k
            tab.value=nextKey
            break
        end
        if k == tab.value then
            found = true
        end
        if i==#tab.possible.keys then
            tab.value=tab.possible.keys[1]
            break
        end
    end
    changeWrapper(tab)
end

function switchPrior(tab)
    for i,v in ipairs(tab.possible.keys) do
        local k=v
        if k == tab.value then
            if i==1 then
                tab.value=tab.possible.keys[#tab.possible.keys]
                break
            end
            local nextKey = tab.possible.keys[i-1]
            tab.value=nextKey
            break
        end
    end
    changeWrapper(tab)
end

function stepSetting(tab,signal)
    if signal>0 then
        tab.value=math.min(tab.value+tab.step,tab.max)
    else
        tab.value=math.max(tab.value-tab.step,tab.min)
    end
end

function stepWrapper(tab)
    local stg = {}
    for k,v in pairs(settings) do
        if tab[1] == v.name then
            stg = v
            break
        end
    end
    stepSetting(stg,tab[2])
    if stg.name=="Volume" then
        changeVolume()
    end
end

function changeWrapper(tab)
    --handle the changes for every config
    local n = tab.name
    if n=="Dificuldade" then
        --change difficulty
        difficulty = tab.possible[tab.value]
    elseif n=="Tema" then
        drawColors = tab.possible[tab.value]
    elseif n=="Tamanho" then
        boardW = tab.possible[tab.value]
        boardH = tab.possible[tab.value]
        resetBoard(0,0)
    end
end

function getMaxSettingsPage()
    --Scales correct
    local widthScale = 1.2
    --if checkMobile()==false then widthScale=2.5 end

    local w = screenw/widthScale
    local h = screenh/1.5
    local x = screenw/2-w/2
    local y = screenh/2-h/2
end