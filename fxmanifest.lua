--[[ FX Information ]]--
fx_version   'cerulean'
use_fxv2_oal 'yes'
lua54        'yes'
game         'gta5'

--[[ Resource Information ]]--
name         'Adam Adminpanel'
version      '1.0.0'
description  'Simple Adminpanel'
license      'GPL-3.0-or-later'
author       'FiveM Land (Adam)'
repository   ''

--[[ Manifest ]]--
dependencies {
	'/server:5104',
	'/onesync',
}

shared_scripts {
    '@es_extended/imports.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/main.lua',
}

ui_page 'ui/ui.html'

files {
    'ui/**'
}
