local updated_times = {}

RemoveUpdating = function (identifier)
    updated_times[identifier] = nil
end

local function updateQuery()
    local query = 'UPDATE users SET users.remainingJailTime = users.remainingJailTime - CASE users.identifier'
    local values = {}
    for playerIdentifier, removedJailtime in pairs(updated_times) do
        query = query .. ' WHEN ? THEN ?'
        values[#values+1] = playerIdentifier
        values[#values+1] = removedJailtime
    end
    query = query.. ' ELSE 0 END'
    MySQL.prepare.await(query, values)
end

lib.callback.register('jail:server:updateJailtime', function (source)
    local src = source
    local xTarget = ESX.GetPlayerFromId(src)
    updated_times[xTarget.getIdentifier()] = updated_times[xTarget.getIdentifier()] == nil and 1 or (updated_times[xTarget.getIdentifier()] + 1)
end)

lib.cron.new('*/15 * * * *', function()
    updateQuery()
end)

AddEventHandler('txAdmin:events:serverShuttingDown', function ()
    updateQuery()
end)

AddEventHandler('onResourceStop', function (resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end
    updateQuery()
end)