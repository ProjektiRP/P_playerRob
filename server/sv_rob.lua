Citizen.CreateThread(function()
    while true do
        if GetCurrentResourceName() ~= 'P_playerRob' then
            print('Change resource ' .. GetCurrentResourceName() .. ' name to P_playerRob')
        end
        Citizen.Wait(60000)
    end
end)
