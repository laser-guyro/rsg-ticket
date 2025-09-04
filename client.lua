local isAdmin = false

RegisterCommand("ticket", function()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "openTicketUI" })
end)

RegisterCommand("tickets", function()
    TriggerServerEvent("ticket:checkAdmin")
end)

RegisterNetEvent("ticket:isAdmin")
AddEventHandler("ticket:isAdmin", function(value, canViewStats)
    isAdmin = value
    if isAdmin then
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "openAdminUI",
            showStatsButton = canViewStats 
        })
    else
        print("Nu ești admin.")
    end
end)

RegisterNUICallback("submitTicket", function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeUI" })

    TriggerServerEvent("ticket:createRequest", data.reason)

    cb(true)
end)

RegisterNetEvent("ticket:createdSuccess")
AddEventHandler("ticket:createdSuccess", function()
    lib.notify({
        title = "Ticket",
        description = "Your ticket has been sent successfully!",
        type = "success",
        duration = 8000
    })
end)


RegisterNUICallback("closeUI", function(_, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeUI" })
    cb(true)
end)

RegisterNUICallback("claimTicket", function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeUI" })
    TriggerServerEvent("ticket:claim", {
        id = data.id,
        target = data.target
    })
    cb(true)
end)

RegisterNetEvent("ticket:updateList")
AddEventHandler("ticket:updateList", function(tickets)
    SendNUIMessage({ action = "updateAdminList", tickets = tickets })
end)

RegisterNetEvent("ticket:teleportToPlayer")
AddEventHandler("ticket:teleportToPlayer", function(targetId)
    local ped = PlayerPedId()
    local targetPlayer = GetPlayerFromServerId(targetId)
    
end)


RegisterNetEvent("ticket:teleportToPlayer")
AddEventHandler("ticket:teleportToPlayer", function(targetId)
    local playerPed = PlayerPedId()
    local targetPlayer = GetPlayerFromServerId(targetId)

    if targetPlayer == -1 then
        lib.notify({
            title = "Teleport",
            description = "Player not found.",
            type = "error",
            duration = 10000
        })
        return
    end

    local targetPed = GetPlayerPed(targetPlayer)
    local coords = GetEntityCoords(targetPed)

    SetEntityCoords(playerPed, coords.x + 1.0, coords.y, coords.z)

    lib.notify({
        title = "Teleport",
        description = "You have been teleported to the player.",
        type = "success",
        duration = 10000
    })
end)

RegisterNetEvent("ticket:newTicketNotify")
AddEventHandler("ticket:newTicketNotify", function(info)
    lib.notify({
        title = "New ticket",
        description = ("Player %s (%s) created a ticket."):format(info.name, info.citizenid),
        type = "inform",
        duration = 10000
    })
end)

RegisterNetEvent("ticket:claimedNotify")
AddEventHandler("ticket:claimedNotify", function(adminName)
    lib.notify({
        title = "Ticket",
        description = ("An admin (%s) is handling your ticket."):format(adminName),
        type = "inform",
        duration = 10000
    })
end)

RegisterNetEvent("ticket:cooldown")
AddEventHandler("ticket:cooldown", function(seconds)
    local minutes = math.ceil(seconds / 60)
    lib.notify({
        title = "Ticket",
        description = ("You already have an active ticket. Wait for an Admin to take over the ticket."):format(minutes),
        type = "error",
        duration = 10000
    })
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeUI" })
end)

RegisterNUICallback("requestStats", function(_, cb)
    TriggerServerEvent("ticket:getStats")
    cb(true)
end)

RegisterNetEvent("ticket:receiveStats")
AddEventHandler("ticket:receiveStats", function(stats)
    SendNUIMessage({
        action = "showStats",
        stats = stats
    })
end)


