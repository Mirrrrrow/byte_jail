utils = {}

utils.sendNotify = function (playerId, data)
    TriggerClientEvent('ox_lib:notify', playerId, data)
end

utils.notifyGroup = function(groups, data)
    if type(groups) == 'string' then groups = { groups } end
    if type(groups) ~= 'table' then error(("expected type 'string' or 'table' (received %s)"):format(type(groups))) end
    for _, jobName in pairs(groups) do
        local xPlayers = ESX.GetExtendedPlayers('job', jobName)
        for _, xPlayer in pairs(xPlayers) do
            utils.sendNotify(xPlayer.source, data)
        end
    end
end

return utils
