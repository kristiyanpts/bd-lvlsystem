fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Kristiyanpts & NeenGame'
description 'Leveling System by Bulgar Development'
version '2.0.0'

shared_script {
	'@ox_lib/init.lua',
	'config.lua',
}

client_scripts {
	'client/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/framework/*.lua',
	'server/*.lua',
}