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
        local response = http_service:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..place_id.."/servers/Public?sortOrder=Asc&limit=100&cursor="..cursor, true))
        if response and response.data then
            for _, server in ipairs(response.data) do
                if server.playing < server.maxPlayers and server.id ~= job_id then
                    table.insert(servers, server.id)
                end
            end
            cursor = response.nextPageCursor or ""
            if cursor == "" then break end
        end
    end

    if #servers > 0 then
        local next_server = servers[math.random(1, #servers)]
        queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/byeelolxd/Nothing/refs/heads/main/main.lua'))()")
        teleport_service:TeleportToPlaceInstance(place_id, next_server, players.LocalPlayer)
    end
end

serverhop()
