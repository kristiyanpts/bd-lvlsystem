local QBCore = exports['qb-core']:GetCoreObject()

-- Functions
local function CanPlayerReceiveExperience(citizenid)
    local Player = QBCore.Functions.GetPlayerByCitizenId(citizenid)

    if Player == nil then return false end

    -- YOUR CUSTOM CHECKS HERE
    -- if Player.PlayerData.dailyLimit >= 10000 then return false end

    return true
end

local function AddReputation(citizenid, job, reputation)
    local Player = QBCore.Functions.GetPlayerByCitizenId(citizenid)

    ::reset::

    local currentReputation = MySQL.query.await('SELECT reputation FROM player_levels WHERE citizenid = @citizenid', {
        ['@citizenid'] = citizenid,
        ['@job'] = job
    })

    if currentReputation[1] == nil then
        if Config["Debug"] then
            print("[BD-LVLSYSTEM] Player " ..
                Player.PlayerData.citizenid .. " does not have any reputation. Adding default ones (set to 0)")
        end

        local reputationRes = MySQL.insert.await(
            'INSERT INTO player_levels (citizenid, reputation) VALUES (@citizenid, @reputation)', {
                ['@citizenid'] = citizenid,
                ['@reputation'] = json.encode(Config["Jobs"])
            })

        goto reset
    else
        currentReputation = json.decode(currentReputation[1]["reputation"])

        if Config["Jobs"][job] ~= nil and currentReputation[job] == nil then
            if Config["Debug"] then
                print("[BD-LVLSYSTEM] Player " ..
                    Player.PlayerData.citizenid ..
                    " does not have any reputation for job " .. job .. ". Adding default ones (set to 0)")
            end

            currentReputation[job] = 0

            local reputationRes = MySQL.update.await(
                'UPDATE player_levels SET reputation = @reputation WHERE citizenid = @citizenid', {
                    ['@citizenid'] = citizenid,
                    ['@reputation'] = json.encode(currentReputation)
                })

            goto reset
        end

        if CanPlayerReceiveExperience(citizenid) then
            currentReputation[job] = tonumber(currentReputation[job]) + reputation

            if currentReputation[job] >= Config.MaxXP then
                currentReputation[job] = Config.MaxXP

                if Player ~= nil then
                    TriggerClientEvent('QBCore:Notify', Player.PlayerData.source,
                        "Достигнахте максималната репутация, която тази работа позволява.", "error", 5000)
                end

                if Config["Debug"] then
                    print("[BD-LVLSYSTEM] Player " ..
                        Player.PlayerData.citizenid ..
                        " has reached the maximum reputation for job " .. job .. " (Max: " .. Config.MaxXP .. ")")
                end
            end

            if Config["Debug"] then
                print("[BD-LVLSYSTEM] Adding " ..
                    reputation ..
                    " to Player " ..
                    Player.PlayerData.citizenid ..
                    " their new reputation is " ..
                    currentReputation[job] .. " for job " .. job .. " (Max: " .. Config.MaxXP .. ")")
            end

            local reputationRes = MySQL.update.await(
                'UPDATE player_levels SET reputation = @reputation WHERE citizenid = @citizenid', {
                    ['@citizenid'] = citizenid,
                    ['@reputation'] = json.encode(currentReputation)
                })
        else
            if Config["Debug"] then
                print("[BD-LVLSYSTEM] Player " ..
                    Player.PlayerData.citizenid ..
                    " has reached their daily limit of money and cannot receive more reputation.")
            end

            if Player ~= nil then
                TriggerClientEvent('QBCore:Notify', Player.PlayerData.source,
                    "Достигнали сте своя дневен лимит и не може да получите повече репутация.", "error", 10000)
            end
        end
    end
end

local function RemoveReputation(citizenid, job, reputation)
    local currentReputation = MySQL.query.await('SELECT reputation FROM player_levels WHERE citizenid = @citizenid', {
        ['@citizenid'] = citizenid,
        ['@job'] = job
    })

    if currentReputation[1] ~= nil then
        currentReputation = json.decode(currentReputation[1]["reputation"])
        currentReputation[job] = currentReputation[job] - reputation

        if Config["Debug"] then
            print("[BD-LVLSYSTEM] Removing " ..
                reputation ..
                " from Player " ..
                citizenid .. " their new reputation is " .. currentReputation[job] .. " for job " .. job)
        end

        local reputationRes = MySQL.update.await(
            'UPDATE player_levels SET reputation = @reputation WHERE citizenid = @citizenid', {
                ['@citizenid'] = citizenid,
                ['@reputation'] = json.encode(currentReputation)
            })
    end
end

local function GetReputation(citizenid, job)
    ::reset::
    local currentReputation = MySQL.query.await('SELECT reputation FROM player_levels WHERE citizenid = @citizenid', {
        ['@citizenid'] = citizenid,
        ['@job'] = job
    })

    if currentReputation[1] ~= nil then
        currentReputation = json.decode(currentReputation[1]["reputation"])

        if currentReputation[job] ~= nil then
            return tonumber(currentReputation[job])
        else
            AddReputation(citizenid, job, 0)

            if Config["Debug"] then
                print("[BD-LVLSYSTEM] Player " ..
                    citizenid .. " does not have any reputation for job " .. job .. ". Adding default ones (set to 0)")
            end

            goto reset
        end
    else
        AddReputation(citizenid, job, 0)

        if Config["Debug"] then
            print("[BD-LVLSYSTEM] Player " ..
                citizenid .. " does not have any reputation for job " .. job .. ". Adding default ones (set to 0)")
        end

        goto reset
    end
end

local function GetPlayerLevel(citizenid, job)
    local reputationForJob = GetReputation(citizenid, job)
    local level = "Rookie" -- Default level

    for k, v in pairs(Config["Levels"]) do
        if reputationForJob >= v.RequiredXP then
            level = k
        end
    end

    return level
end

local function GetPlayerReputationAndLevel(citizenid, job)
    local reputationForJob = GetReputation(citizenid, job)
    local playerLevel = GetPlayerLevel(citizenid, job)

    return reputationForJob, playerLevel
end


exports("AddReputation", AddReputation)
exports("RemoveReputation", RemoveReputation)
exports("GetReputation", GetReputation)
exports("GetPlayerLevel", GetPlayerLevel)
exports("GetPlayerReputationAndLevel", GetPlayerReputationAndLevel)

-- Callbacks
lib.callback.register('bd-lvlsystem:server:get-reputation-by-job', function(source, job)
    local Player = QBCore.Functions.GetPlayer(source)

    if Player ~= nil then
        local reputation = GetReputation(Player.PlayerData.citizenid, job)

        if reputation == false then
            if Config["Debug"] then
                print("[BD-LVLSYSTEM] Player " ..
                    Player.PlayerData.citizenid .. " does not have reputation for job " .. job)
            end

            return false
        end

        return reputation
    end
end)
