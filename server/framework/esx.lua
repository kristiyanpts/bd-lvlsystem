if Config["Framework"] ~= 'esx' then return end

local Framework = exports["es_extended"]:getSharedObject()

function GetPlayer(source)
    return Framework.GetPlayerFromId(source)
end

function GetPlayerIdf(source)
    local player = GetPlayer(source)
    return player.identifier
end

function GetPlayerByIdf(Idf)
    local Player = Framework.GetPlayerFromIdentifier(Idf)
    local Data = {
        identifier = Player.identifier,
        source = Player.source,
    }
    return Data
end

function Notify(source, text, type, length)
    local Player = GetPlayer(source)
    Player.showNotification(text)
end