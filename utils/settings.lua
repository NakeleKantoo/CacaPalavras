function loadSettings()
    local obj = {}
    if love.filesystem.getInfo("config.json") then
        obj = json.decode(love.filesystem.read("config.json"))
    else
        love.filesystem.write("config.json",json.encode(getSettingsDefault()))
        obj=getSettingsDefault()
    end
    return obj,5
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
        ["12x12"] = 12,
        ["5x5"] = 5,
        ["7x7"] = 7,
        keys = {"5x5","7x7","10x10","12x12"}
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
            text = {1,1,1},
            foundWord = {1, 0.627, 0.239}
        },
        ["Azul"] = { --TODO
            gameBack = {0.082,0.176,0.318},
            shading = {0,0,0.15},
            back = {0.157,0.288,0.475},
            underline = {0.501,0.633,0.823},
            button = {0.257,0.388,0.575},
            buttonHighlight = {0.157,0.288,0.575},
            buttonPress = {0.057,0.188,0.475},
            text = {1,1,1},
            foundWord = {1, 0.239, 0.239}
        },
        ["Vermelho"] = { --TODO
            gameBack = {0.506,0.188,0.188},
            shading = {0.406,0.088,0.088},
            back = {0.558,0.103,0.103},
            underline = {0.799,0.333,0.333},
            button = {0.675,0.267,0.267},
            buttonHighlight = {0.670,0.2,0.2},
            buttonPress = {0.570,0.1,0.1},
            text = {1,1,1},
            foundWord = {0.627, 1, 0.239}
        },
        ["Verde"] = { --TODO
            gameBack = {0.078,0.239,0.039},
            shading = {0,0.139,0},
            back = {0.153,0.373,0.098},
            underline = {0.559,0.904,0.472},
            button = {0.253,0.473,0.198},
            buttonHighlight = {0.153,0.473,0.098},
            buttonPress = {0.053,0.373,0},
            text = {1,1,1},
            foundWord = {1, 1, 0.3}
        },
        ["Escuro"] = {
            gameBack = {0.15,0.15,0.15},
            shading = {0.1,0.1,0.1, 0.65},
            back = {0.2,0.2,0.2},
            underline = {1,1,1},
            button = {0.6,0.6,0.6},
            buttonHighlight = {0.8,0.8,0.8},
            buttonPress = {0.55,0.55,0.55},
            text = {1,1,1},
            foundWord = {1, 0.627, 0.239}
        },
        ["Marrom"] = { --TODO
            gameBack = {0.229,0.142,0.052},
            shading = {0.029,0,0},
            back = {0.434,0.264,0.090},
            underline = {0.940,0.671,0.396},
            button = {0.434,0.264,0},
            buttonHighlight = {0.343,0.164,0},
            buttonPress = {0.353,0.064,0},
            text = {1,1,1},
            foundWord = {1,0.3,1}
        },
        keys = {"Roxo","Vermelho","Verde","Azul","Marrom","Escuro"}
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
    --total pages
    local pages = 1
    local maxperpage = 0
    local updating = true

    --Scales correct
    local widthScale = 1.2
    --if checkMobile()==false then widthScale=2.5 end

    local aw = screenw/widthScale
    local ah = screenh/1.5
    local ax = screenw/2-aw/2
    local ay = screenh/2-ah/2

    --to check for max pages
    local y=ay+font:getHeight()*2+textfont:getHeight()+5
    for i=1,numSettings do
        y=y+font:getHeight()*2+textfont:getHeight()+5
        --check if this is inside the bounding box
        local h = font:getHeight()+18+math.max(font:getWidth("+"),font:getHeight())
        if y >= ay and y+h <= ay+ah then
        else
            pages = pages+1
            updating=false
            --reset the y
            y=ay+font:getHeight()*2+textfont:getHeight()+5
        end
        if updating then maxperpage=maxperpage+1 end
    end
    --yea this kind of works.
    return pages, maxperpage
end

function getSettingsDefault()
    local obj ={
        hardSetting = {id=1,value="Médio",name="Dificuldade",possible=loadPossibleDifficulties()},
        volume = {id=2,value=100,name="Volume",min=0,max=100,step=5},
        theme = {id=3,value="Roxo",name="Tema",possible=loadPossibleThemes()},
        size = {id=4,value="10x10",name="Tamanho",possible=loadPossibleSizes()},
        numWords = {id=5,value=10,name="Nº Palavras",min=5,max=15,step=1}
    }
    return obj
end

function saveSettings()
    love.filesystem.write("config.json",json.encode(settings))
end

