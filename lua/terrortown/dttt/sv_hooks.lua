function GM:DTTTPreMuteLogic() end
function GM:DTTTPreDeafenLogic() end

function GM:DTTTPreLogic() end

---

function GM:DTTTPreMute(ply, duration)
    if hook.Run("DTTTPreMuteLogic") ~= nil or hook.Run("DTTTPreLogic") ~= nil then return end

    hook.Run("DTTTMute", ply, duration)
end

function GM:DTTTMute(ply, duration)
    g_player_state_manager.mute(ply, duration)

    hook.Run("DTTTPostMute", ply, duration, hook.Run("DTTTGetMuted", ply))
end

function GM:DTTTPostMute(ply, duration, state) end

---

function GM:DTTTPreUnmute(ply, duration)
    if hook.Run("DTTTPreMuteLogic") ~= nil or hook.Run("DTTTPreLogic") ~= nil then return end

    hook.Run("DTTTUnmute", ply, duration)
end

function GM:DTTTUnmute(ply, duration)
    g_player_state_manager.unmute(ply, duration)

    hook.Run("DTTTPostUnmute", ply, duration, hook.Run("DTTTGetMuted", ply))
end

function GM:DTTTPostUnmute(ply, duration, state) end

---

function GM:DTTTPreMuteAll(duration)
    if hook.Run("DTTTPreMuteLogic") ~= nil or hook.Run("DTTTPreLogic") ~= nil then return end

    hook.Run("DTTTMuteAll", duration)
end

function GM:DTTTMuteAll(duration)
    g_player_state_manager.muteAll(duration)

    hook.Run("DTTTPostMuteAll", duration, g_player_state_manager.getAllMuted())
end

function GM:DTTTPostMuteAll(duration, player_states) end

---

function GM:DTTTPreUnmuteAll(duration)
    if hook.Run("DTTTPreMuteLogic") ~= nil or hook.Run("DTTTPreLogic") ~= nil then return end

    hook.Run("DTTTUnmuteAll", duration)
end

function GM:DTTTUnmuteAll(duration)
    g_player_state_manager.unmuteAll(duration)

    hook.Run("DTTTPostUnmuteAll", duration, g_player_state_manager.getAllMuted())
end

function GM:DTTTPostUnmuteAll(duration, player_states) end

---
---
---

function GM:DTTTPreDeafen(ply, duration)
    if hook.Run("DTTTPreDeafenLogic") ~= nil or hook.Run("DTTTPreLogic") ~= nil then return end

    hook.Run("DTTTDeafen", ply, duration)
end

function GM:DTTTDeafen(ply, duration)
    g_player_state_manager.deafen(ply, duration)

    hook.Run("DTTTPostDeafen", ply, duration, hook.Run("DTTTGetDeafened"))
end

function GM:DTTTPostDeafen(ply, duration, state) end

---

function GM:DTTTPreUndeafen(ply, duration) 
    if hook.Run("DTTTPreDeafenLogic") ~= nil or hook.Run("DTTTPreLogic") ~= nil then return end
end

function GM:DTTTUndeafen(ply, duration)
    g_player_state_manager.undeafen(ply, duration)

    hook.Run("DTTTPostUndeafen", ply, duration, hook.Run("DTTTGetDeafened"))
end

function GM:DTTTPostUndeafen(ply, duration, state) end

---

function GM:DTTTPreDeafenAll(duration)
    if hook.Run("DTTTPreDeafenLogic") ~= nil or hook.Run("DTTTPreLogic") ~= nil then return end

    hook.Run("DTTTDeafenAll", duration)
end

function GM:DTTTDeafenAll(duration)
    g_player_state_manager.deafenAll(duration)

    hook.Run("DTTTPostDeafenAll", duration, hook.Run("DTTTGetAllDeafened"))
end

function GM:DTTTPostDeafenAll(duration, player_states) end

---

function GM:DTTTPreUndeafenAll(duration)
    if hook.Run("DTTTPreDeafenLogic") ~= nil or hook.Run("DTTTPreLogic") ~= nil then return end

    hook.Run("DTTTUndeafenAll", duration)
end

function GM:DTTTUndeafenAll(duration)
    g_player_state_manager.undeafenAll(duration)

    hook.Run("DTTTPostUndeafenAll", duration, hook.Run("DTTTGetAllDeafened"))
end

function GM:DTTTPostUndeafenAll(duration, player_states) end

---
---
---

-- TODO CHANNEL MOVE

---
---
---

function GM:DTTTGetAllMuted()
    return g_player_state_manager.getAllMuted()
end

function GM:DTTTGetAllDeafened()
    return g_player_state_manager.getAllDeafened()
end

function GM:DTTTGetDiscordIDs()
    return g_discord_mapper.getAllMappings()
end

function GM:DTTTGetMuted(ply)
    return g_player_state_manager.getMuted(ply)
end

function GM:DTTTGetDeafened(ply)
    return g_player_state_manager.getDeafened(ply)
end

function GM:DTTTGetID(ply)
    g_discord_mapper.getMapping(ply)
end

---
---
---

local function muteWithChat(ply)
    timer.Simple(0.2, function()
        local can_use_text_chat = hook.Run("TTT2AvoidGeneralChat", ply, "")
        local can_use_voice_chat = hook.Run("TTT2CanUseVoiceChat", ply, false)

        if (can_use_text_chat == false or can_use_voice_chat == false) and getRoundState() == 3 then
            hook.Run("DTTTPreMute", ply)
        else
            hook.Run("DTTTPreUnmute", ply)
        end
    end)
end

hook.Add("TTT2PrePrepareRound", "DTTTPrePrepareRound", function(duration)
    if hook.Run("DTTTPreInternalLogic") ~= nil then return end

    hook.Run("DTTTPreUnmuteAll")
end)

hook.Add("TTT2PreEndRound", "DTTTPreBeginRonud", function(result, duration)
    if hook.Run("DTTTPreInternalLogic") ~= nil then return end

    hook.Run("DTTTPreUnmuteAll")
end)

hook.Add("TTT2PostPlayerDeath", "DTTTPostPlayerDeath", function(victim, inflictor, attacker)
    if hook.Run("DTTTPreInternalLogic") ~= nil then return end

    if getRoundState() ~= 3 then return end

    hook.Run("DTTTPreMute", victim, GetConVar("dttt_mute_duration"):GetInt())
end)

hook.Add("PlayerSpawn", "DTTTPlayerSpawn", function(ply, transition)
    if hook.Run("DTTTPreInternalLogic") ~= nil then return end
    muteWithChat(ply)
end)

hook.Add("PlayerInitialSpawn", "DTTTPlayerInitialSpawn", function(ply ,transition)
    g_player_state_manager.initPlayer(ply)
    g_discord_mapper.autoMap(ply)
end)

hook.Add("PlayerDisconnected", "DTTTPlayerDisconnected", function(ply)
    g_player_state_manager.deinitPlayer(ply)
end)