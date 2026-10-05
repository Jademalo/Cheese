--------------------------------------------------------------------------------
--Variables
--------------------------------------------------------------------------------
local addonName = ...
local cheeseFrame = CreateFrame("Frame", "cheese", UIParent)
if not CheesePrevLevelTime then
    CheesePrevLevelTime = 0
end


--------------------------------------------------------------------------------
--Event Registration
--------------------------------------------------------------------------------
cheeseFrame:RegisterEvent("ADDON_LOADED")
cheeseFrame:RegisterEvent("PLAYER_LEVEL_UP") --Register the level up event to re-trigger the max cover after maxing


--------------------------------------------------------------------------------
--Functions
--------------------------------------------------------------------------------
local function formatTime(totalSeconds)

    local days = math.floor(totalSeconds / 86400)
    local hours = math.floor((totalSeconds % 86400) / 3600)
    local minutes = math.floor((totalSeconds % 3600) / 60)
    local seconds = totalSeconds % 60

    local function pluralEnd(var)
        if var ~= 1 then
            return "s"
        else
            return ""
        end
    end

    return days.." day"..pluralEnd(days)..", "..hours.." hour"..pluralEnd(hours)..", "..minutes.." minute"..pluralEnd(minutes)..", "..seconds.." second"..pluralEnd(seconds)
end


--------------------------------------------------------------------------------
--Event Handler
--------------------------------------------------------------------------------
cheeseFrame:SetScript("OnEvent", function(self, event, arg1, arg2)

    if event == "ADDON_LOADED" and arg1 == addonName then
        --Make sure that screenshot quality is at maximum for jpeg
        if C_CVar.GetCVar("screenshotFormat") == "jpeg" then
            C_CVar.SetCVar("screenshotQuality", 10)
        end
    end

    if event == "PLAYER_LEVEL_UP" then
        RequestTimePlayed() --Show /played when levelling up
        cheeseFrame:RegisterEvent("TIME_PLAYED_MSG") --Register the return of the message being sent to screenshot
    end

    if event == "TIME_PLAYED_MSG" then
        local lastLevel = arg1 - CheesePrevLevelTime
        CheesePrevLevelTime = arg1

        print("|cffffff00Time played last level: "..formatTime(lastLevel).."|r")
        C_Timer.After(0.5, function() Screenshot() end) --Take a screenshot on Level Up

        cheeseFrame:UnregisterEvent("TIME_PLAYED_MSG") --Unregister the event so it doesn't fire on every /played
    end

end)
