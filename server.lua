KEY = 0
require 'modules.officer.server'
require 'modules.prisoner.server'

Citizen.CreateThreadNow(function ()
    local success, _  = pcall(MySQL.scalar.await, 'SELECT remainingJailTime FROM users')
    if not success then
        lib.print.debug("could not find 'remainingJailTime' from 'users': creating column")
        MySQL.query.await([[
            ALTER TABLE users ADD COLUMN remainingJailTime INT(32) NOT NULL DEFAULT 0
        ]])
    end
end)