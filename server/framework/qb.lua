if Config["Framework"] ~= 'qb' then return end
local Framework = exports['qb-core']:GetCoreObject()

function GetPlayer(source)
    return Framework.Functions.GetPlayer(source)
end

function GetPlayerIdf(source)
    local Player = GetPlayer(source)
    return Player.PlayerData.citizenid
end

function GetPlayerByIdf(Idf)
    local Player = Framework.Functions.GetPlayerByCitizenId(Idf)
    local Data = {
        identifier = Player.PlayerData.citizenid,
        source = Player.PlayerData.source,
    }
    return Data
end

function Notify(source, text, type, length)
    Framework.Functions.Notify(source, text, type, length)
end