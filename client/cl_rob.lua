ESX = nil
local PlayingAnim = false

Citizen.CreateThread(function()
    while not ESX do
        ESX = exports['es_extended']:getSharedObject()
        Citizen.Wait(0)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(1)
    end
end

function IsPlayerArmed() -- Check if player have weapon in hand
    local player = PlayerId()
    return IsPedArmed(PlayerPedId(), 4)
end

function IsPlayersNearby()
    local closestPlayer, distance = ESX.Game.GetClosestPlayer()
    return closestPlayer ~= -1 and distance <= 1.5
end

function IsArmedWithKnife() -- Check if player have melee weapon in hand
    local player = PlayerId()
    local weapon = GetSelectedPedWeapon(PlayerPedId())

    local knifeHashes = {
        GetHashKey("WEAPON_KNIFE") -- You can add more melee weapons
    }

    for _, hash in ipairs(knifeHashes) do
        if weapon == hash then
            return true
        end
    end

    return false
end

function RobPlayer()
    local player = PlayerPedId()

    if (IsPlayerArmed() or IsArmedWithKnife()) and IsPlayersNearby() then
        local closestPlayer, distance = ESX.Game.GetClosestPlayer()

        if distance <= 1.5 then
            local closestPlayerPed = GetPlayerPed(closestPlayer)
            local closestPlayerHasHandsUp = IsEntityPlayingAnim(closestPlayerPed, "random@mugging3", "handsup_standing_base", 3)

            if closestPlayerHasHandsUp or IsPlayerDead(closestPlayer) then
                exports['mythic_progbar']:Progress({ display = true, duration = 8500, label = "Searching..." })
                PlayingAnim = true

                -- Animation before opening the inventory, you can change animation if you want.
                LoadAnimDict("mini@repair")
                TaskPlayAnim(player, "mini@repair", "fixing_a_ped", 1.0, -1.0, -1, 49, 0, false, false, false)
                Citizen.Wait(8500)

                -- Stop animation when searching timer is 0
                ClearPedTasks(player)
                PlayingAnim = false

                exports.ox_inventory:openInventory('player', GetPlayerServerId(closestPlayer))
            else
                ESX.ShowNotification('Player dont have hands up!') -- Show notification if player don't have hands up, you can change text "Player dont have hands up!" if you want.
            end
        else
            ESX.ShowNotification('No players nearby!') -- Show notification if no players nearby, you can change text "No players nearby!" if you want.
        end
    end
end

-- Command --
RegisterCommand('rob', function() -- Default command is "rob", you can change it.
    RobPlayer()
end)

-- Register keybind --
RegisterKeyMapping('rob', 'Rob player', 'keyboard', 'G') -- Default button is "G", you can change it.