fx_version 'cerulean'
lua54 'yes'
description 'Leveling System by Bulgar Development'
game 'gta5'
author 'kristiyanpts'

shared_script {
	'config.lua',
	'@ox_lib/init.lua',
}

client_scripts {
	'client/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua', 
	'server/*.lua',
}

dependency '/assetpacks'

escrow_ignore {
    'config.lua',
}