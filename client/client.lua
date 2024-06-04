local function GetReputation(job)
    local reputationForJob = lib.callback.await('bd-lvlsystem:server:get-reputation-by-job', false, job)

    if reputationForJob then
        return reputationForJob
    else
        return 0
    end
end

local function GetPlayerLevel(job)
    local reputationForJob = GetReputation(job)
    local level = "Rookie" -- Default level

    for k, v in pairs(Config["Levels"]) do
        if reputationForJob >= v.RequiredXP then
            level = k
        end
    end

    return level
end

local function GetPlayerReputationAndLevel(job)
    local reputationForJob = GetReputation(job)
    local playerLevel = GetPlayerLevel(job)

    return reputationForJob, playerLevel
end

exports("GetReputation", GetReputation)
exports("GetPlayerLevel", GetPlayerLevel)
exports("GetPlayerReputationAndLevel", GetPlayerReputationAndLevel)
