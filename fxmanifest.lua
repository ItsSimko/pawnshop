fx_version 'adamant'
game 'common'

lua54 'yes'

ui_page 'web/web.html'

files {
  'web/web.html',
  'web/*.js',
  'web/*.css',
}

client_scripts {
  '@PolyZone/client.lua',
  '@PolyZone/BoxZone.lua',
  '@PolyZone/ComboZone.lua',
  'client/*.lua',
}

server_scripts {
  'server/*.lua',
}