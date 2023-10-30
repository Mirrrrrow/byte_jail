-- Resource Metadata
fx_version 'cerulean'
games { 'gta5' }
use_experimental_fxv2_oal 'yes'
lua54 'yes'

author 'ByteScripts'
description 'Jail System'
--version 'Development Build'
version 'Alpha'

-- Manifest
dependencies {
    'oxmysql',
    'ox_lib',
}

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
}

client_script 'init.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'init.lua'
}

files {
    'client.lua',
    'server.lua',
    'data/*.*',
    'modules/**/client.lua',
}
