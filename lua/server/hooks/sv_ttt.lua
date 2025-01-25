include("server/hooks/sv_dttt.lua")

-- Unmute all
hook.Add("TTT2PrePrepareRound", "DTTTPrePrepareRound", function(duration)
    if isInternalUnmuteEnabled() then
        hook.Run("DTTTUnmuteAll")
    end
    hook.Run("DTTTPost")
end)

-- Unmute all
hook.Add("TTT2PreEndRound", "DTTTPreBeginRonud", function(result, duration)
    if isInternalUnmuteEnabled() then
        hook.Run("DTTTUnmuteAll")
    end
end)

-- Mute Player
hook.Add("TTT2PostPlayerDeath", "DTTTPostPlayerDeath", function(victim, inflictor, attacker)
    if isInternalMuteEnabled() then
        hook.Run("DTTTMute", victim, GetConVar("dttt_mute_duration"):GetInt())
    end
end)

-- Unmute Player
hook.Add("PlayerSpawn", "DTTTPlayerSpawn", function(ply, transition)
    if isInternalUnmuteEnabled() then
        hook.Run("DTTTUnmute", ply)
    end
end)


-- Map Discord ID
hook.Add("PlayerInitialSpawn", "DTTTPlayerInitialSpawn", function(ply ,transition)
    -- automap id
    if GetConVar("dttt_auto_map_ids"):GetBool() then
        autoMapId(ply)
    end
end)

-- Try unmute player
hook.Add("PlayerDisconnected", "DTTTPlayerDisconnected", function(ply)
    return
    --timer.Simple(0.2, function() hook.Run(HOOKS.UNMUTE_PLAYER, ply) end)
end)