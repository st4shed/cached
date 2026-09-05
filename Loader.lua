local GameList = {}

GameList["Steal an Egg"] = {
    Name = "Steal an Egg",
    PlaceIds = {107778070777162},
    UniverseIds = {10563114921},
    Url = "https://raw.githubusercontent.com/st4shed/cached/refs/heads/main/Games/sae.lua"
}

local function foundGame()
    local pid = game.PlaceId
    local uid
    pcall(function() uid = game.GameId end)
    for _, info in pairs(GameList) do
        if info.PlaceIds then
            for _, id in ipairs(info.PlaceIds) do
                if id == pid then return info end
            end
        end
        if uid and info.UniverseIds then
            for _, id in ipairs(info.UniverseIds) do
                if id == uid then return info end
            end
        end
    end
    -- fallback by name match (your structure)
    for _, info in pairs(GameList) do
        if info.Name == "Steal an Egg" and pid == 107778070777162 then return info end
    end
    return nil
end

local gameInfo = foundGame()
if not gameInfo then
    warn("[cached-loader] unsupported game: " .. game.PlaceId)
    return
end

local ok, err = pcall(function()
    local src = game:HttpGet(gameInfo.Url)
    assert(src and #src > 0, "empty response")
    loadstring(src, gameInfo.Name)()
end)

if not ok then
    warn("[cached-loader] failed to load " .. gameInfo.Name .. ": " .. tostring(err))
end
