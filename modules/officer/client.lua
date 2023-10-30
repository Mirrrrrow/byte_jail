local builder = require 'modules.menubuilder.client'
CreateThread(function()
    while not ESX.PlayerLoaded do
        Wait(500)
    end

    if not client.isAllowed then
        client.isAllowed = utils.checkJob(settings.allowedJobs)
    end

    lib.points.new({
        coords = settings.positions.jailIn,
        distance = 2.5,
        onEnter = function(self)
            if client.isAllowed then
                lib.showTextUI(settings.locales['press_e_to_jail'])
            end
        end,
        onExit = function(self)
            if client.isAllowed then
                lib.hideTextUI()
            end
        end,
        nearby = function(self)
            if IsControlJustReleased(0, 38) then
                if client.isAllowed then
                    builder.requestJailIn()
                end
            end
        end
    })

    lib.points.new({
        coords = settings.positions.managePlayers,
        distance = 2.5,
        onEnter = function (self)
            if client.isAllowed then
                lib.showTextUI(settings.locales['press_e_to_manage'])
            end
        end,
        onExit = function (self)
            if client.isAllowed then
                lib.hideTextUI()
            end
        end,
        nearby = function (self)
            if IsControlJustReleased(0, 38) then
                if client.isAllowed then
                    builder.requestJailManager()
                end
            end
        end
    })
end)
