utils = {}

utils.checkJob = function (job)
    if type(job) == 'string' then return ESX.PlayerData.job.name == job end
    if type(job) ~= 'table' then error(("expected type 'string' or 'table' (received %s)"):format(type(job))) end
    for _, jobName in pairs(job) do
        if jobName == ESX.PlayerData.job.name then return true end
    end
    return false
end

---@param data NotifyProps
utils.sendNotify = function (data)
    lib.notify(data)
end

return utils