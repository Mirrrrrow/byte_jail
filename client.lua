require 'modules.officer.client'
require 'modules.prisoner.client'

local utils = require 'modules.utils.client'
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    ESX.PlayerLoaded = true
    client.isAllowed = utils.checkJob(settings.allowedJobs)
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
    ESX.PlayerLoaded = false
    ESX.PlayerData = {}
    client.isAllowed = false
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    client.isAllowed = utils.checkJob(settings.allowedJobs)
end)
