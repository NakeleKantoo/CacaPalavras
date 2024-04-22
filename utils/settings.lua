function loadSettings()
    local obj = {
        hardSetting = {id=1,value="Médio",name="Dificuldade",possible=loadPossibleDifficulties()},
        volume = {id=2,value=100,name="Volume",min=0,max=100,step=5},
        theme = {id=3,value="Roxo",name="Tema",possible=loadPossibleThemes()}
    }
    return obj,3
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
        ["Azul"] = {
            gameBack = {0.211, 0.09, 0.368},
            shading = {0.117, 0.0, 0.254, 0.65},
            back = {0.403, 0.227, 0.713},
            underline = {0.659, 0.435, 1},
            button = {0.501, 0.337, 0.643},
            buttonHighlight = {0.584, 0.454, 0.803},
            buttonPress = {0.294, 0.192, 0.509},
            foundWord = {1, 0.627, 0.239}
        },
        ["Vermelho"] = {
            gameBack = {0.211, 0.09, 0.368},
            shading = {0.117, 0.0, 0.254, 0.65},
            back = {0.403, 0.227, 0.713},
            underline = {0.659, 0.435, 1},
            button = {0.501, 0.337, 0.643},
            buttonHighlight = {0.584, 0.454, 0.803},
            buttonPress = {0.294, 0.192, 0.509},
            foundWord = {1, 0.627, 0.239}
        },
        ["Verde"] = {
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
            gameBack = {0.211, 0.09, 0.368},
            shading = {0.117, 0.0, 0.254, 0.65},
            back = {0.403, 0.227, 0.713},
            underline = {0.659, 0.435, 1},
            button = {0.501, 0.337, 0.643},
            buttonHighlight = {0.584, 0.454, 0.803},
            buttonPress = {0.294, 0.192, 0.509},
            foundWord = {1, 0.627, 0.239}
        },
        ["Laranja"] = {
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
end