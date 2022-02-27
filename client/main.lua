local nuiFocus = false
local showedUI = false
local speed = false
local god = false
local superjump = false
local invisible = false


ADMIN_LEVELS = {
    ['admin'] = true,
    ['superadmin'] = true
}

-- Panel open
RegisterCommand(
    'adminpanel',
    function()
        ESX.TriggerServerCallback(
            'PlayerGroup',
            function(group)
                if ADMIN_LEVELS[group] then
                    showedUI = not showedUI

                    if showedUI then
                        showUI(group)
                    else
                        hideUI()
                    end
                end
            end
        )
    end
)

RegisterKeyMapping('adminpanel', 'Admin Panel', 'keyboard', 'INSERT')

-- Functions

function showUI(group)
    SendNUIMessage(
        {
            playerCount = #GetActivePlayers(),
            group = group,
            action = 'showUI'
        }
    )
    SetNuiFocus(true, true)
end

function hideUI()
    SendNUIMessage(
        {
            action = 'hideUI'
        }
    )
    SetNuiFocus(false, false)
    showedUI = false
end

-- NUI Callback

RegisterNUICallback('close', hideUI)

RegisterNUICallback(
    'speedrun',
    function()
        speed = not speed
        SendNUIMessage(
            {
                action = 'alert',
                msg = speed and 'bekapcsolva' or 'kikapcsolva',
                title = 'Speedrun',
                color = speed and 'success' or 'danger'
            }
        )
        SetRunSprintMultiplierForPlayer(PlayerId(), speed and 1.49 or 1.0)
    end
)

RegisterNUICallback(
    'godmode',
    function()
        god = not god
        SendNUIMessage(
            {
                action = 'alert',
                msg = god and 'bekapcsolva' or 'kikapcsolva',
                title = 'Godmode',
                color = god and 'success' or 'danger'
            }
        )
        SetPlayerInvincible(PlayerId(), god)
    end
)

RegisterNUICallback(
    'superjump',
    function()
        CreateThread(
            function()
                superjump = not superjump
                SendNUIMessage(
                    {
                        action = 'alert',
                        msg = superjump and 'bekapcsolva' or 'kikapcsolva',
                        title = 'Superjump',
                        color = superjump and 'success' or 'danger'
                    }
                )
                while superjump do
                    SetSuperJumpThisFrame(PlayerId(), false)
                    Wait(0)
                end
            end
        )
    end
)

RegisterNUICallback(
    'invisible',
    function()
        invisible = not invisible
        SetEntityVisible(PlayerPedId(), not invisible)
        SendNUIMessage(
            {
                action = 'alert',
                msg = invisible and 'bekapcsolva' or 'kikapcsolva',
                title = 'Láthatatlanság',
                color = invisible and 'success' or 'danger'
            }
        )
    end
)

RegisterNUICallback(
    'copycoords',
    function(data, cb)
        local playerPed = PlayerPedId()
        local posX, posY, posZ = table.unpack(GetEntityCoords(playerPed))

        cb({position = posX .. ', ' .. posY .. ', ' .. posZ})
    end
)
