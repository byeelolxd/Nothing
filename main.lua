repeat task.wait() until game:IsLoaded()

local http_service = game:GetService("HttpService")
local teleport_service = game:GetService("TeleportService")
local players = game:GetService("Players")
local place_id = game.PlaceId
local job_id = game.JobId

local function serverhop()
    local servers = {}
    local cursor = ""

    for _ = 1, 8 do
        task.wait(1.5)
        local success, result = pcall(function()
            return http_service:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..place_id.."/servers/Public?sortOrder=Asc&limit=100&cursor="..cursor, true))
        end)

        if success and result and result.data then
            for _, server in ipairs(result.data) do
                if server.playing < server.maxPlayers and server.id ~= job_id then
                    table.insert(servers, server.id)
                end
            end
            cursor = result.nextPageCursor or ""
            if cursor == "" then break end
        else
            break
        end
    end

    if #servers > 0 then
        local next_server = servers[math.random(1, #servers)]
        queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/byeelolxd/Nothing/refs/heads/main/main.lua'))()")
        teleport_service:TeleportToPlaceInstance(place_id, next_server, players.LocalPlayer)
    end
end

serverhop()
