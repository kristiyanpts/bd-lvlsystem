Config = {
    ["Debug"] = false, -- Set to false if you don't want to see debug messages in the console
    ["Framework"] = "qb", -- Set to "esx" if you are using ESX framework, "qb" if you are using QBCore framework
    ["Language"] = 'EN', -- Set to 'EN' for English, 'BG' for Bulgarian
    ["MaxXP"] = 300, -- Maximum reputation for a job
    ["Levels"] = { -- Levels and required XP for each level
        ["Rookie"] = {
            Label = "Rookie",
            RequiredXP = 0,
        },
        ["Proficient"] = {
            Label = "Proficient",
            RequiredXP = 100,
        },
        ["Expert"] = {
            Label = "Expert",
            RequiredXP = 200,
        },
        ["Professional"] = {
            Label = "Professional",
            RequiredXP = 300,
        },
    },
    ["Jobs"] = {
        ["gruppe"] = 0,
        ["clicklovers"] = 0,
        ["wine"] = 0,
        ["deliveries"] = 0,
        ["tow"] = 0,
        ["sanitation"] = 0,
    },
    ["Translation"] = {
        ['EN'] = {
            ['MaxRep'] = "You have reached the maximum reputation this job allows.",
            ['MaxDailyRep'] = "You have reached your daily limit and cannot receive more reputation.",
        },
        ['BG'] = {
            ['MaxRep'] = "Достигнахте максималната репутация, която тази работа позволява.",
            ['MaxDailyRep'] = "Достигнали сте своя дневен лимит и не може да получите повече репутация.",
        }
    }
}