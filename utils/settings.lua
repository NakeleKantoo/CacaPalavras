function loadSettings()
    local obj = {
        hardSetting = {value="Médio",name="Dificuldade",possible=loadPossibleDifficulties()},
        volume = {value=100,name="Volume",min=0,max=100,step=5}
    }
    return obj,2
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