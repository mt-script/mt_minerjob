fx_version 'cerulean'
game 'gta5'

author 'Matula123 / MT Scripts'
description 'Miner JOB'
version '1.0.0'

shared_script 'config.lua'

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'ox_target',
    'ox_inventory',
    'ox_lib',
    'es_extended', -- pokud používáš ESX
}
