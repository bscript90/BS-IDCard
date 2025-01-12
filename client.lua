local current = {}
local movements = {}
local prompts = GetRandomIntInRange(0, 0xffffff)

local function createPrompts(keysTable, prompts)
    local array = {}
    for _, keyData in pairs(keysTable) do
        local str = "TEST"
        local movement = PromptRegisterBegin() 
        PromptSetControlAction(movement, keyData[2])
        str = CreateVarString(10, 'LITERAL_STRING', keyData[1])
        PromptSetText(movement, str)
        PromptSetEnabled(movement, 1)
        PromptSetVisible(movement, 1)
        PromptSetStandardMode(movement, 1)
        PromptSetGroup(movement, prompts)
        Citizen.InvokeNative(0xC5F428EE08FA7F2C, movement, true)
        PromptRegisterEnd(movement)
        table.insert(array, movement) 
        PromptSetHoldMode(movement, 500)
    end
    return array
end

local keysTable = {
    {"Take ID Card", 0x2CD5343E},
}

local function spawnPed(v)
    local modelHash = GetHashKey(v.model)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Citizen.Wait(10)
    end
    local npc = CreatePed(modelHash, v.coords.x, v.coords.y, v.coords.z-1, v.coords.w, false, 0)
    FreezeEntityPosition(npc, true)
    Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
    SetEntityCanBeDamaged(npc, false)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetModelAsNoLongerNeeded(modelHash)
    SetEntityAsMissionEntity(npc, true, true)
    if v.anims and v.anims.name then
        RequestAnimDict(v.anims.dict)
        while not HasAnimDictLoaded(v.anims.dict) do
            Citizen.Wait(100)
        end
        TaskPlayAnim(npc, v.anims.dict, v.anims.name, 1.0, -1.0, -1, 1, 0, true, 0, false, 0, false)
    elseif v.anims then
        TaskStartScenarioInPlace(npc, GetHashKey(v.anims.dict), 0, true, false, false, false)
    end
    return npc
end

RegisterNetEvent('BS-IDCard:client:openRegister',function(data)
    SetNuiFocus(true,true)
    SendNUIMessage(data)
end)

RegisterNUICallback('register',function(data)
    SetNuiFocus(false,false)
    TriggerServerEvent('BS-IDCard:server:createIDCard',data)
end)
RegisterNUICallback('close',function(data)
    SetNuiFocus(false,false)
end)
RegisterNUICallback('save',function(data)

    TriggerServerEvent('BS-IDCard:server:update',current,data)
    SetNuiFocus(false,false)
end)

RegisterNetEvent('BS-IDCard:client:openIDCard',function(item)
    current = item
    SetNuiFocus(true,true)
    SendNUIMessage({
        action = "openIDCard",
        data = item.metadata.idcarddata,
        pagecount = Config.PageCount
    })
end)

Citizen.CreateThread(function()
    for k,v in pairs(Config.Towns) do
        local blip = N_0x554d9d53f696d002(1664425300, v.coords.x,v.coords.y,v.coords.z)
        Citizen.InvokeNative(0x0DF2B55F717DDB10, blip, false)
        Citizen.InvokeNative(0x662D364ABF16DE2F, blip, joaat(v.blips.modifier))
        SetBlipSprite(blip, v.blips.sprite, 1)
        SetBlipScale(blip, v.blips.scale)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, v.blips.name)
        v.BLIPID = blip
    end
    movements = createPrompts(keysTable, prompts)
    while true do
        local sleep = 2000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        for k,v in pairs(Config.Towns) do
            local dist = #(vector3(v.coords.x,v.coords.y,v.coords.z) - coords) 
            if dist < 3 then
                sleep = 1
                local title = CreateVarString(10, 'LITERAL_STRING',"Identity")
              
                PromptSetActiveGroupThisFrame(prompts, title)
                if PromptHasHoldModeCompleted(movements[1]) then
                    Wait(50)
                    TriggerServerEvent('BS-IDCard:server:openRegister', k)
                end
            elseif dist < 40 and not v.NPC then
                v.NPC = spawnPed(v)
            elseif dist > 40 and v.NPC then
                DeleteEntity(v.NPC)
                v.NPC = nil
            end
        end
        Wait(sleep)
    end
end)


AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    for k,v in pairs(Config.Towns) do
        if v.NPC then
            DeletePed(v.NPC)
        end
        if v.BLIPID then
            RemoveBlip(v.BLIPID)
        end
    end
end)
