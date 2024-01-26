Citizen.CreateThread(function()
    while true do
        if GetCurrentResourceName() ~= 'ox_playerRob' then
            print('Change resource ' .. GetCurrentResourceName() .. ' name to ox_playerRob')
        end
        Citizen.Wait(60000)
    end
end)