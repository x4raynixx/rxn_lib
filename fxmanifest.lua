fx_version 'cerulean'
games { 'gta5' }
author 'Raynixx'
lua54 'yes'

export {
    'stopResource',
    'restartResource',
    'startResource',
    'RegisterInstructionalMenu',
    'AddInstructionalMenuButton',
    'UnregisterInstructionalMenuButton',
    'UnregisterInstructionalMenu',
    'ShowInstructionalMenu',
    'showNotificationToPlayer',
    'getFramework',
    'ShowNotificationMenu',
}

client_scripts {
    'client/**'
}

server_scripts {
    'server/**'
}

shared_scripts {
    'config.lua'
}

escrow_ignore {
    'config.lua'
}

files {
    'web/**'
}

ui_page 'web/index.html'