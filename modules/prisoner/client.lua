local utils = require 'modules.utils.client'

local gettingFreed = false
local currentTime = 0
local timeToAdd = 0
local function start_jail(time, firstTime)
    CreateThread(function()
        TriggerEvent('skinchanger:getSkin', function(skin)
            if skin['sex'] == 0 then
                TriggerEvent('skinchanger:loadClothes', skin, settings.clothes.male)
            else
                TriggerEvent('skinchanger:loadClothes', skin, settings.clothes.female)
            end
        end)

        gettingFreed = false
        currentTime = time
        utils.sendNotify({
            title = settings.locales['notify_title'],
            description = settings.locales['jail_info']:format(time),
            type = 'info',
            icon = 'handcuffs',
            duration = 5000
        } --[[@as NotifyProps]])

        if firstTime then
            local insideJail = settings.positions.insideJail
            ---@diagnostic disable-next-line: missing-parameter
            SetEntityCoords(cache.ped, insideJail.x, insideJail.y, insideJail.z)
        end

        local waitingTime = 60 * 1000 -- 60 seconds
        local startTime = GetGameTimer()

        while time > 0 and not gettingFreed do
            local currGameTime = GetGameTimer()
            local elapsedTime = currGameTime - startTime

            if elapsedTime >= waitingTime then
                time -= 1
                startTime = currGameTime
                lib.callback.await('jail:server:updateJailtime', false)
                currentTime = time
            end

            if timeToAdd ~= 0 then
                if time + timeToAdd <= 0 then
                    gettingFreed = true
                    time = 0
                    currentTime = time
                else
                    time += timeToAdd
                    timeToAdd = 0
                    currentTime = time
                end
            end

            if gettingFreed then
                break
            end

            Wait(0)
        end

        local outsideJail = settings.positions.outsideJail
        ---@diagnostic disable-next-line: missing-parameter
        SetEntityCoords(cache.ped, outsideJail.x, outsideJail.y, outsideJail.z)
        utils.sendNotify({
            title = settings.locales['notify_title'],
            type = 'info',
            description = settings.locales['jail_finished'],
            icon = 'handcuffs',
            duration = 5000
        })

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin)
        end)
    end)
end

if settings.commands.jailtime.use then
    RegisterCommand(settings.commands.jailtime.name, function(source, args, raw)
        if currentTime > 0 then
            utils.sendNotify({
                title = settings.locales['notify_title'],
                type = 'info',
                description = settings.locales['current_jail_time']:format(currentTime),
                icon = 'handcuffs'
            } --[[@as NotifyProps]])
        else
            utils.sendNotify({
                title = settings.locales['notify_title'],
                type = 'error',
                description = settings.locales['not_in_jail'],
                icon = 'handcuffs'
            } --[[@as NotifyProps]])
        end
    end, false)
end

RegisterNetEvent('jail:client:freePlayer', function(data)
    local success = lib.callback.await('jail:server:checkKey', false, data.key)
    if not success then return end
    gettingFreed = true
end)

RegisterNetEvent('jail:client:addJailtime', function(data)
    local success = lib.callback.await('jail:server:checkKey', false, data.key)
    if not success then return end
    timeToAdd = data.time
end)

RegisterNetEvent('jail:client:delJailtime', function(data)
    local success = lib.callback.await('jail:server:checkKey', false, data.key)
    if not success then return end
    timeToAdd = -data.time
end)

RegisterNetEvent('jail:client:startJail', function(data)
    local success = lib.callback.await('jail:server:checkKey', false, data.key)
    if not success then return end
    start_jail(data.time, data.firstTime)
end)

CreateThread(function()
    while not ESX.PlayerLoaded do
        Wait(1000)
    end
    lib.callback.await('jail:server:checkTime', false)
end)
