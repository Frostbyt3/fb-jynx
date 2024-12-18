fx_version 'cerulean'
game 'gta5'

description 'FB-Jynx'
version '1.2.0'

ui_page 'html/meter.html'

shared_scripts {
    '@qb-core/shared/locale.lua',
    '@ox_lib/init.lua',
    '@oxmysql/lib/MySQL.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua',
}

dependencies {
    'qb-core',
    'PolyZone',
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/main.lua',
}

server_scripts {
    'server/main.lua',
}

files {
    'html/meter.css',
    'html/meter.html',
    'html/meter.js',
    'html/reset.css',
    'html/fb-meter.png'
}

lua54 'yes'
