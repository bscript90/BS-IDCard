Config = {}
Config.Framework = "VORP" -- RSG / VORP

Config.Towns = {
    ["Black Water"] = {
        coords = vector4(-798.0041, -1245.3615, 43.4748, 175.2779),
        model = "cs_brontesbutler",
        blips = {
            name = "IDENTITY",
            sprite = -1656531561,
            scale = 0.6,
            modifier = "BLIP_MODIFIER_MP_COLOR_32",
        },
        anims = {
            dict = "WORLD_HUMAN_SMOKE_NERVOUS_STRESSED",
            name = false,
        },
    },
    ["Strawberry"] = {
        coords = vector4(-1803.5564, -345.7397, 164.4913, 210.3091),
        model = "cs_brontesbutler",
        blips = {
            name = "IDENTITY",
            sprite = -1656531561,
            scale = 0.6,
            modifier = "BLIP_MODIFIER_MP_COLOR_32",
        },
        anims = {
            dict = "WORLD_HUMAN_SMOKE_NERVOUS_STRESSED",
            name = false,
        },
    },
    ["Valentine"] = {
        coords = vector4(-175.3824, 631.9274, 114.1396, 322.0134),
        model = "cs_brontesbutler",
        blips = {
            name = "IDENTITY",
            sprite = -1656531561,
            scale = 0.6,
            modifier = "BLIP_MODIFIER_MP_COLOR_32",
        },
        anims = {
            dict = "WORLD_HUMAN_SMOKE_NERVOUS_STRESSED",
            name = false,
        },
    },
    ["Rhodes"] = {
        coords = vector4(1230.2253, -1298.4535, 76.9544, 216.9492),
        model = "cs_brontesbutler",
        blips = {
            name = "IDENTITY",
            sprite = -1656531561,
            scale = 0.6,
            modifier = "BLIP_MODIFIER_MP_COLOR_32",
        },
        anims = {
            dict = "WORLD_HUMAN_SMOKE_NERVOUS_STRESSED",
            name = false,
        },
    },
    ["Armadillo"] = {
        coords = vector4(-3729.1255, -2601.2808, -12.8877, 181.9450),
        model = "cs_brontesbutler",
        blips = {
            name = "IDENTITY",
            sprite = -1656531561,
            scale = 0.6,
            modifier = "BLIP_MODIFIER_MP_COLOR_32",
        },
        anims = {
            dict = "WORLD_HUMAN_SMOKE_NERVOUS_STRESSED",
            name = false,
        },
    },
    ["Saint Denis"] = {
        coords = vector4(2510.2656, -1308.9792, 49.0036, 270.7017),
        model = "cs_brontesbutler",
        blips = {
            name = "IDENTITY",
            sprite = -1656531561,
            scale = 0.6,
            modifier = "BLIP_MODIFIER_MP_COLOR_32",
        },
        anims = {
            dict = "WORLD_HUMAN_SMOKE_NERVOUS_STRESSED",
            name = false,
        },
    },
}
Config.PageCount = 3

function Notify(data)
    local text = data.text or "No message" 
    local time = data.time or 5000  
    local type = data.type or "info" 
    local src = data.source

    if IsDuplicityVersion() then
        if Config.Framework == "RSG" then
            TriggerClientEvent('ox_lib:notify', src, { title = text, type = type, duration = time })
        elseif Config.Framework == "VORP" then
            TriggerClientEvent("vorp:TipBottom",src, text, time, type)
        end
    else
        if Config.Framework == "RSG" then
            TriggerEvent('ox_lib:notify', { title = text, type = type, duration = time })
        elseif Config.Framework == "VORP" then
            TriggerEvent("vorp:TipBottom", text, time, type)
        end
    end
end