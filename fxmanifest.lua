fx_version 'bodacious'
game 'gta5'

shared_script 'config.lua'

client_scripts {
	'lang.lua',
	'client.lua'
}
server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}

ui_page 'ui/index.html'

files {
	'ui/index.html',
	'ui/css/*.css',
	'ui/js/*.js',
	'ui/img/*.png',
}