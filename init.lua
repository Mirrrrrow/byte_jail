SECOND = 60 * 1000
MINUTE = 60 * SECOND
HOUR = 60 * MINUTE
DAY = 24 * HOUR


Shared = {}

settings = require 'data.settings'

if IsDuplicityVersion() then
    server = {}
else
    client = {}
end

if lib.context == 'server' then
    local resource = GetCurrentResourceName()

    local currentVersion = GetResourceMetadata(resource, 'version', 0)
    if currentVersion == 'Development Build' then
        warn('You are running a development build of the Jail System. Please do not use this in production.')
    end
    return require 'server'
end

require 'client'
