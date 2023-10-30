local utils = require 'modules.utils.server'
local logging = require 'modules.logging.server'
lib.callback.register('jail:server:requestJail', function (source, targetId, time, caseNumber)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(targetId)
    if not xPlayer or not xTarget then return utils.sendNotify(xPlayer.source, {
        title = settings.locales['notify_title'],
        type = 'error',
        icon = 'handcuffs',
        description = settings.locales['player_not_found']
    }--[[@as NotifyProps]]) end

    local currentTime = MySQL.scalar.await('SELECT remainingJailTime FROM users WHERE identifier = ?', {xTarget.getIdentifier()})
    if currentTime > 0 then
        return utils.sendNotify(xPlayer.source, {
            title = settings.locales['notify_title'],
            type = 'error',
            icon = 'handcuffs',
            description = settings.locales['player_in_jail']
        }--[[@as NotifyProps]])
    end
    utils.notifyGroup(settings.allowedJobs, {
        title = settings.locales['notify_title'],
        type = 'info',
        icon = 'handcuffs',
        description = settings.locales['player_got_jailed']:format(xTarget.getName())
    } --[[@as NotifyProps]])

    MySQL.update('UPDATE users SET remainingJailTime = ? WHERE identifier = ?', {
        time, xTarget.getIdentifier()
    })

    KEY = math.random(11111111, 99999999)
    TriggerClientEvent('jail:client:startJail', xTarget.source, {
        time = time,
        firstTime = true,
        key = KEY
    })

    logging.log( 'default', {xTarget.getName(), xPlayer.getName(), time, caseNumber})
end)

lib.callback.register('jail:server:checkTime', function (source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local results = MySQL.scalar.await('SELECT remainingJailTime FROM users WHERE identifier = ?', {xPlayer.getIdentifier()})
    if results <= 0 then return end
    KEY = math.random(11111111, 99999999)
    TriggerClientEvent('jail:client:startJail', xPlayer.source, {
        time = results,
        firstTime = false,
        key = KEY
    })
end)

lib.callback.register('jail:server:requestManagePlayers', function (source)
    local players, num = {}, 0
    local results = MySQL.query.await('SELECT identifier, remainingJailTime FROM users WHERE remainingJailTime > 0')
    for _, result in pairs(results) do
        local xTarget = ESX.GetPlayerFromIdentifier(result.identifier)
        if xTarget then
            num += 1
            players[num] = {
                name = xTarget.getName(),
                time = result.remainingJailTime
            }
        end
    end
    return players
end)

lib.callback.register('jail:server:freePlayer', function (source, targetName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetExtendedPlayers('name', targetName)[1]
    if not xTarget then return utils.sendNotify(xPlayer.source, {
        title = settings.locales['notify_title'],
        type = 'error',
        icon = 'handcuffs',
        description = settings.locales['player_not_found']
    }--[[@as NotifyProps]]) end

    KEY = math.random(11111111, 99999999)
    TriggerClientEvent('jail:client:freePlayer', xTarget.source, {
        key = KEY
    })
    logging.log( 'free', {xTarget.getName(), xPlayer.getName()})

    RemoveUpdating(xTarget.getIdentifier())
    MySQL.update.await('UPDATE users SET remainingJailTime = 0 WHERE identifier = ?', {xTarget.getIdentifier()})
end)


lib.callback.register('jail:server:addTime', function (source, targetName, time)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetExtendedPlayers('name', targetName)[1]
    if not xTarget then return utils.sendNotify(xPlayer.source, {
        title = settings.locales['notify_title'],
        type = 'error',
        icon = 'handcuffs',
        description = settings.locales['player_not_found']
    }--[[@as NotifyProps]]) end

    KEY = math.random(11111111, 99999999)
    TriggerClientEvent('jail:client:addJailtime', xTarget.source, {
        key = KEY,
        time = time
    })
    utils.sendNotify(xPlayer.source, {
        title = settings.locales['notify_title'],
        type = 'success',
        icon = 'handcuffs',
        description = settings.locales['time_edited']
    }--[[@as NotifyProps]])
    logging.log('expand', {xTarget.getName(), xPlayer.getName(), time})
end)

lib.callback.register('jail:server:delTime', function (source, targetName, time)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetExtendedPlayers('name', targetName)[1]
    if not xTarget then return utils.sendNotify(xPlayer.source, {
        title = settings.locales['notify_title'],
        type = 'error',
        icon = 'handcuffs',
        description = settings.locales['player_not_found']
    }--[[@as NotifyProps]]) end

    KEY = math.random(11111111, 99999999)
    TriggerClientEvent('jail:client:delJailtime', xTarget.source, {
        key = KEY,
        time = time
    })
    utils.sendNotify(xPlayer.source, {
        title = settings.locales['notify_title'],
        type = 'success',
        icon = 'handcuffs',
        description = settings.locales['time_edited']
    }--[[@as NotifyProps]])
    logging.log('del', {xTarget.getName(), xPlayer.getName(), time})
end)

lib.callback.register('jail:server:checkKey', function (source, key)
    return KEY == key
end)