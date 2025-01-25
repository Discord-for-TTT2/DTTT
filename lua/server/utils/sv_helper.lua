--- CON VARS ---

function shouldAutoMapId()
    return GetConVar("dttt_auto_map_ids"):GetBool()
end

function shouldCacheIDs()
    return GetConVar("dttt_cache_mapping"):GetBool()
end

--- CONVERTERS ---

--[[
    Converts the players SteamID64 into a string
    @param ply (Player) the player to convert
    @return The converted steamID into a string
]]
function playerIdToString(ply)
    return tostring(ply:SteamID64())
end


--- Checkers ---

function isInternalMuteEnabled()
    local mute_logic_enabled = GetConVar("dttt_imute_logic_enabled"):GetBool()
    local mute_enabled = GetConVar("dttt_imute_enabled"):GetBool()

    return mute_logic_enabled and mute_enabled
end

function isInternalUnmuteEnabled()
    local mute_logic_enabled = GetConVar("dttt_imute_logic_enabled"):GetBool()
    local unmute_enabled = GetConVar("dttt_iunmute_enabled"):GetBool()

    return mute_logic_enabled and unmute_enabled
end

--[[
    Returns if the player is muted
    @param ply (Player) the player to retrieve the muted state from
    @return The muted state of the player  
]]
function isPlayerMuted(ply)
    return g_dttt_player_states.muted[playerIdToString(ply)]
end

--[[
    Returns if the player is deafened
    @param ply (Player) the player to retrieve the deafened state from
    @return The deafened state of the player  
]]
function isPlayerDeafened(ply)
    return g_dttt_player_states.deafened[playerIdToString(ply)]
end

--[[
    Checks if the player is mapped
    @param ply (Player) the player that 
]]
function hasMappedId(ply)
    return g_dttt_discord_mapping[playerIdToString(ply)] ~= nil
end

function shouldAutoMapId()
    return GetConVar("dttt_auto_map_ids"):GetBool()
end

function shouldCacheIDs()
    return GetConVar("dttt_cache_mapping"):GetBool()
end

--- Getters ---

--[[
    Gets the current round state where: 1=XXX|2=XXX|3=Active|4=XXX
    @returns The current round state
]]
function getRoundState()
    if gmod.GetGamemode().Name == "TTT2" or gmod.GetGamemode().Name == "TTT2 (Advanced Update)" then
        return GetRoundState()
    end

    return nil
end

function getMappedId(ply)
    if not hasMappedId(ply) then
        logError("Unable to get Mapped ID, player " .. ply:Nick() .. " is not mapped")
        return nil
    end

    return g_dttt_discord_mapping[playerIdToString(ply)]
end

function getMuteState(ply)
    return g_dttt_player_states.muted[playerIdToString(ply)] or false
end

function getDeafenState(ply)
    return g_dttt_player_states.deafened[playerIdToString(ply)] or false
end

function containsPlayerMute(ply)
    return g_dttt_player_states.muted[playerIdToString(ply)] ~= nil
end

function containsPlayerDeafen(ply)
    return g_dttt_player_states.deafened[playerIdToString(ply)] ~= nil
end

function addPlayerStates(ply)
    logInfo("Adding states for player " .. ply:Nick())

    if not containsPlayerMute(ply) then
        g_dttt_player_states.muted[playerIdToString(ply)] = false
    end

    if not containsPlayerDeafen(ply) then
        g_dttt_player_states.deafened[playerIdToString(ply)] = false
    end
end

function removePlayerStates(ply)
    logInfo("Removing states for player " .. ply:Nick())

    g_dttt_player_states.muted[playerIdToString(ply)] = nil
    g_dttt_player_states.deafened[playerIdToString(ply)] = nil
end

--- Setters ---

function setMuteState(ply, state)
    if not containsPlayerMute(ply) then
        logWarning("Player not in Player States: Mute, wont change")
        return
    end
    g_dttt_player_states.muted[playerIdToString(ply)] = state
end

function setDeafenState(ply, state)
    if not containsPlayerDeafen(ply) then
        logWarning("Player not in Player States: Deafened, wont change")
        return
    end

    g_dttt_player_states.deafened[playerIdToString(ply)] = state
end