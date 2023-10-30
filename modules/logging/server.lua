logging = {
    settings = {
        url = '',
        username = 'Gefängnis-Logs',
        profilePicture = 'https://image.stern.de/7561920/t/5H/v4/w1440/r1/-/affen-selfie-peta-david-slater.jpg',
        title = 'Staatsgefängnis - Los Santos',
        color = nil,
        messages = {
            default = '**%s** got jailed in by **%s** for **%s min** (Case number: **%s**).',
            free = '**%s** got freed by **%s**.',
            expand = '**%s** got a jailtime added by. **%s** (+**%sm**).',
            del = '**%s** got removed jailtime by **%s** (-**%sm**).',
        }
    }
}

logging.log = function (type, data)
    local settings = logging.settings

    PerformHttpRequest(settings.url, function(statusCode, text, headers)
    end, "POST", json.encode({
        embeds = {
            {
                title = settings.title,
                color = settings.color,
                description = settings.messages[type]:format(table.unpack(data))
            }
        },
        username = settings.username,
        avatar_url = settings.profilePicture
    }), {
        ["Content-Type"] = "application/json"
    })
end

return logging