fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
author 'Laser Guy'
description 'Ticket system with cooldown and notifications'
version '1.1.0'


shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}


client_scripts {
    'client.lua'
}


server_scripts {
    '@mysql-async/lib/MySQL.lua', 
    'server.lua'
}


ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/img/*'
}


dependencies {
    'ox_lib'
}

lua54 'yes'

