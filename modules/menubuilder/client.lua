local utils = require 'modules.utils.client'
builder = {}

builder.requestTimeInput = function(cb)
    local retval = lib.inputDialog(settings.locales['jail_input_title'], {
        {
            label = settings.locales['time_input_field_title']:format(settings.time.min, settings.time.max),
            type = 'number',
            min = settings.time.min,
            max = settings.time.max,
            description = settings.locales['time_input_field_desc'],
            required = true
        },
        {
            label = settings.locales['case_number_input_field_title'],
            type = 'textarea',
            description = settings.locales['case_number_input_field_desc'],
            required = true
        }
    })
    if not retval then return false end
    return retval
end

builder.requestJailIn = function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer(cache.coords)
    if (closestPlayer == -1 or closestDistance > 3.0) and not settings.developmentMode then
        return utils.sendNotify({
            title = settings.locales['notify_title'],
            description = settings.locales['no_player_nearby'],
            duration = 5000,
            icon = 'handcuffs',
            type = 'error'
        } --[[@as NotifyProps ]])
    end
    local inputData = builder.requestTimeInput()
    if not inputData then
        return utils.sendNotify({
            title = settings.locales['notify_title'],
            description = settings.locales['jail_canceled'],
            duration = 5000,
            icon = 'handcuffs',
            type = 'error'
        } --[[@as NotifyProps]])
    end

    local time, caseNumber = table.unpack(inputData)
    lib.callback.await('jail:server:requestJail', false,
        GetPlayerServerId(closestPlayer == -1 and PlayerId() or closestPlayer), time, caseNumber)
end

builder.requestJailManager = function()
    if not client.isAllowed then return end
    local players = lib.callback.await('jail:server:requestManagePlayers', false)
    local elements, num = {}, 0
    for _, player in pairs(players) do
        num += 1
        elements[num] = {
            title = player.name .. ' | ' .. player.time .. 'm',
            description = settings.locales['view_more'],
            onSelect = function(_)
                lib.registerContext({
                    id = 'jail_manager_' .. player.name,
                    title = player.name,
                    options = {
                        {
                            title = settings.locales['free_player'],
                            description = settings.locales['view_more'],
                            icon = 'question',
                            onSelect = function(args)
                                local retval = lib.alertDialog({
                                    header = settings.locales['notify_title'],
                                    centered = true,
                                    cancel = true,
                                    content = settings.locales['free_confirm']:format(player.name)
                                })
                                if retval ~= 'confirm' then
                                    return utils.sendNotify({
                                        title = settings.locales['notify_title'],
                                        icon = 'handcuffs',
                                        description = settings.locales['change_canceled'],
                                        type = 'error'
                                    } --[[@as NotifyProps]])
                                end
                                if not client.isAllowed then return end
                                lib.callback.await('jail:server:freePlayer', false, player.name)
                            end
                        },
                        --[[{
                            title = settings.locales['add_time'],
                            description = settings.locales['view_more'],
                            icon = 'question',
                            onSelect = function(args)
                                local retval = lib.inputDialog(settings.locales['notify_title'], {
                                    {
                                        label = settings.locales['add_time_input_title'],
                                        description = settings.locales['add_time_input_desc'],
                                        type = 'number',
                                        min = 0,
                                        max = settings.time.max,
                                    }
                                })
                                if not client.isAllowed then return end
                                if not retval or not retval[1] then return end
                                lib.callback.await('jail:server:addTime', false, player.name, retval[1])
                            end
                        },
                        {
                            title = settings.locales['remove_time'],
                            description = settings.locales['view_more'],
                            icon = 'question',
                            onSelect = function(args)
                                local retval = lib.inputDialog(settings.locales['notify_title'], {
                                    {
                                        label = settings.locales['del_time_input_title'],
                                        description = settings.locales['del_time_input_desc'],
                                        type = 'number',
                                        min = 0,
                                    }
                                })
                                if not client.isAllowed then return end
                                if not retval or not retval[1] then return end
                                lib.callback.await('jail:server:delTime', false, player.name, retval[1])
                            end
                        },--]]
                    }
                })
                lib.showContext('jail_manager_' .. player.name)
            end
        }
    end
    if num == 0 then
        return utils.sendNotify({
            title = settings.locales['notify_title'],
            description = settings.locales['no_players'],
            duration = 5000,
            icon = 'handcuffs',
            type = 'info'
        } --[[@as NotifyProps]])
    end

    lib.registerContext({
        id = 'jail_manager',
        title = settings.locales['notify_title'],
        options = elements
    })
    lib.showContext('jail_manager')
end

return builder
