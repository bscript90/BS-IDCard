
RegisterNetEvent('BS-IDCard:server:openRegister',function(town)
    local src = source
    local current_time = os.date("*t")

    local Character = BSGetName(src)
    local data = {
        action = "register",
        town = town,
        name = Character.firstname.." "..Character.lastname,
        currenttime = string.format("%02d %s 1899", current_time.day, os.date("%B", os.time(current_time)))
    }
    TriggerClientEvent('BS-IDCard:client:openRegister',src,data)
end)

RegisterNetEvent('BS-IDCard:server:createIDCard',function(data)
    local src = source
    BSAddItem(src,"idcard",1,{
        idcarddata = data,
        description = data.nameinput.."'s IDCard <input type='hidden' value='"..math.random(1,999999).."'>"
    })
    Notify({
        source = src,
        text = "IDCard successfully received!",
        time = 5000,
        type = "success"
    })
end)

RegisterNetEvent('BS-IDCard:server:update',function(item,newData)
    local src = source
    BSRemoveItem(src,"idcard",1,item.metadata)
    item.metadata.idcarddata.html = newData.html 
    item.metadata.idcarddata.image = newData.image
    BSAddItem(src,"idcard",1,item.metadata)
    Notify({
        source = src,
        text = "IDCard Saved!",
        time = 5000,
        type = "error"
    })
end)

BSRegisterUsableItem("idcard",function(data)
    local src = data.source
    local item = data.item
    if item.metadata and item.metadata.idcarddata then
        TriggerClientEvent('BS-IDCard:client:openIDCard',src,item)
    else
        Notify({
            source = src,
            text = "IDCard Error! Please register",
            time = 5000,
            type = "error"
        })
    end
end)