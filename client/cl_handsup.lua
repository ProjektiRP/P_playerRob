-- Hands up --
local canHandsUp = true
handsup = false
local TIME                            = {}
TIME.Time                            = 0

AddEventHandler("handsup:toggle", function(param)
    canHandsUp = param
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local lPed = GetPlayerPed(-1)
        RequestAnimDict("random@mugging3")
        if canHandsUp then
            if IsControlJustPressed(1, 20) and (GetGameTimer() - TIME.Time) > 150 then -- Default button is "Z" you can change it. (https://docs.fivem.net/docs/game-references/controls/)
                if handsup then
                    if DoesEntityExist(lPed) then
                        Citizen.CreateThread(function()
                            RequestAnimDict("random@mugging3")
                            while not HasAnimDictLoaded("random@mugging3") do
                                Citizen.Wait(100)
                            end

                            if handsup then
                                handsup = false
                                ClearPedSecondaryTask(lPed)
                            end
                        end)
                    end
                else
                    if DoesEntityExist(lPed) then
                        Citizen.CreateThread(function()
                            RequestAnimDict("random@mugging3")
                            while not HasAnimDictLoaded("random@mugging3") do
                                Citizen.Wait(100)
                            end

                            if not handsup then
                                handsup = true
                                TaskPlayAnim(lPed, "random@mugging3", "handsup_standing_base", 1.2, 1.2, -1, 49, 0, 0, 0, 0)
                            end
                        end)
                    end
                end
                
                TIME.Time  = GetGameTimer()
            end

        end
    end
end)

-- Surrender --
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local playerPed = PlayerPedId()
        if handsup then
            ESX.ShowHelpNotification('[~r~X~w~] Surrender') -- When you have hands up and you press "X" you surrender
            if IsControlJustReleased(0, 73) then -- Default button is "X" you can change it. (https://docs.fivem.net/docs/game-references/controls/)
                ExecuteCommand("e surrender")
            end
            -- When hands are up all these is disabled --
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1
            DisableControlAction(0, 80, true) -- Reload
            DisableControlAction(0, 288, true) -- Disable phone
            DisableControlAction(0, 289, true) -- Inventory
            DisableControlAction(0, 167, true) -- Job
            DisableControlAction(0, 59, true) -- Disable steering in vehicle
            DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
            DisableControlAction(0, 72, true) -- Disable reversing in vehicle
            DisableControlAction(0, 47, true)  -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
            DisableControlAction(0, 75, true)  -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
        else
            Citizen.Wait(500)
        end
    end
end)