local RSGCore = exports["rsg-core"]:GetCoreObject()

local ticketCooldowns = {}
local COOLDOWN_TIME = 10 * 60 -- 10 minutes cooldown before you can make another ticket

function getCitizenID(src)
    local Player = RSGCore.Functions.GetPlayer(src)
    if Player and Player.PlayerData and Player.PlayerData.citizenid then
        return Player.PlayerData.citizenid
    end
    return "unknown"
end

MySQL.ready(function()
    print("[Ticket System] MySQL connected")
end)

RegisterServerEvent("ticket:checkAdmin")
AddEventHandler("ticket:checkAdmin", function()
    local src = source
    local ids = GetPlayerIdentifiers(src) or {}
    local isAdmin = false
    local hasStatsAccess = false

    for _, id in pairs(ids) do
        for _, adminID in pairs(AdminIDs or {}) do
            if id == adminID then
                isAdmin = true
            end
        end
        for _, statID in pairs(StatAdminLicenses or {}) do
            if id == statID then
                hasStatsAccess = true
            end
        end
    end

    TriggerClientEvent("ticket:isAdmin", src, isAdmin, hasStatsAccess == true)

    if isAdmin then
        loadTickets(src)
    end
end)





RegisterServerEvent("ticket:createRequest")
AddEventHandler("ticket:createRequest", function(reason)
    local src = source
    local now = os.time()

    if ticketCooldowns[src] and (now - ticketCooldowns[src]) < COOLDOWN_TIME then
        local remaining = COOLDOWN_TIME - (now - ticketCooldowns[src])
        TriggerClientEvent("ticket:cooldown", src, remaining)
        return
    end

    ticketCooldowns[src] = now

    local name = GetPlayerName(src)
    local citizenid = getCitizenID(src)

    MySQL.insert("INSERT INTO tickets (player_name, player_id, player_cid, reason, status) VALUES (?, ?, ?, ?, 'open')", {
        name, src, citizenid, reason
    }, function()
        notifyAdmins()



        TriggerClientEvent("ticket:createdSuccess", src)
        TriggerEvent("ticket:notifyAdminsOfNewTicket", {
            name = name,
            citizenid = citizenid
        })
    end)
end)


RegisterServerEvent("ticket:claim")
AddEventHandler("ticket:claim", function(data)
    local src = source
    local ticketId = data.id

    local AdminPlayer = RSGCore.Functions.GetPlayer(src)
local adminCid = AdminPlayer and AdminPlayer.PlayerData.citizenid or "unknown"


    local TargetPlayer = RSGCore.Functions.GetPlayer(tonumber(data.target) or data.target)
local targetOnline = TargetPlayer ~= nil

local target = data.target -- id-ul playerului, dacă e online
local targetName = targetOnline and GetPlayerName(target) or 'OFFLINE'
local targetCitizenId = targetOnline and TargetPlayer.PlayerData.citizenid or 'OFFLINE'



    local adminName = GetPlayerName(src)

    MySQL.query('SELECT player_name, reason FROM tickets WHERE id = ?', {ticketId}, function(result)
        if result and result[1] then
            local playerName = result[1].player_name
            local reason = result[1].reason or "Mesaj indisponibil"

            MySQL.update("UPDATE tickets SET status = 'claimed', claimed_by = ? WHERE id = ?", {
                src, ticketId
            }, function()
               if targetOnline then
                TriggerClientEvent("ticket:teleportToPlayer", src, target)
                TriggerClientEvent("ticket:claimedNotify", target, adminName)
            end

                notifyAdmins()

            MySQL.insert("INSERT INTO ticket_stats (admin_id, admin_name) VALUES (?, ?)", {
                adminCid, adminName
                 })

            end)
        end
    end)
end)



RegisterServerEvent("ticket:notifyAdminsOfNewTicket")
AddEventHandler("ticket:notifyAdminsOfNewTicket", function(info)
    for _, playerId in pairs(GetPlayers()) do
        local ids = GetPlayerIdentifiers(playerId)
        for _, id in ipairs(ids) do
            for _, adminID in ipairs(AdminIDs) do
                if id == adminID then
                    print("[Ticket] Notificare trimisă către admin:", playerId)
                    TriggerClientEvent("ticket:newTicketNotify", playerId, info)
                end
            end
        end
    end
end)

function notifyAdmins()
    MySQL.query("SELECT * FROM tickets WHERE status = 'open'", {}, function(tickets)
        for _, playerId in pairs(GetPlayers()) do
            local ids = GetPlayerIdentifiers(playerId)
            for _, id in pairs(ids) do
                for _, adminID in pairs(AdminIDs) do
                    if id == adminID then
                        TriggerClientEvent("ticket:updateList", playerId, tickets)
                    end
                end
            end
        end
    end)
end

function loadTickets(src)
    MySQL.query("SELECT * FROM tickets WHERE status = 'open'", {}, function(tickets)
        TriggerClientEvent("ticket:updateList", src, tickets)
    end)
end

RegisterServerEvent("ticket:getStats")
AddEventHandler("ticket:getStats", function()
    local src = source

    MySQL.query([[
        SELECT admin_name,
               COUNT(*) as total,
               SUM(CASE WHEN timestamp >= NOW() - INTERVAL 30 DAY THEN 1 ELSE 0 END) as last_30_days
        FROM ticket_stats
        GROUP BY admin_name
        ORDER BY total DESC
    ]], {}, function(results)
        TriggerClientEvent("ticket:receiveStats", src, results)
    end)
end)


