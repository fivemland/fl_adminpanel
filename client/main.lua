local showedUI = false
local speedrun = false
local god = false
local superjump = false
local invisible = false

function checkAdmin()
    local p = promise.new()

    ESX.TriggerServerCallback('adminpanel:PlayerGroup', function(isAdmin)
        p:resolve(isAdmin)
    end)

    return Citizen.Await(p)
end

RegisterAdminNUICallback = function(name, cb)
    RegisterNUICallback(name, function(...)
        if not showedUI then 
            return
        end

        cb(...)
    end)
end

-- Panel open
RegisterCommand(
    'adminpanel',
    function()
        if not checkAdmin() then 
            return
        end
        showedUI = not showedUI

        if showedUI then
            showUI(group)
        else
            hideUI()
        end
    end
)
RegisterKeyMapping('adminpanel', 'Admin Panel', 'keyboard', 'INSERT')

-- Functions
function showUI(group)
    SendNUIMessage(
        {
            AdminCommands = AAP.AdminCommands,
            playerCount = #GetActivePlayers(),
            group = group,
            action = 'showUI',
            inDuty = isPlayerInAdminduty()
        }
    )
    SetNuiFocus(true, true)
end

function hideUI(_, cb)
    SendNUIMessage(
        {
            action = 'hideUI'
        }
    )
    SetNuiFocus(false, false)
    showedUI = false

    if cb then
        cb('ok')
    end
end

-- NUI Callback

RegisterNUICallback('close', hideUI)

RegisterAdminNUICallback(
    'Speedrun',
    function()
        speedrun = not speedrun
        SendNUIMessage(
            {
                action = 'alert',
                msg = speedrun and 'Speedrun: bekapcsolva' or 'Speedrun: kikapcsolva',
                color = speedrun and 'success' or 'danger'
            }
        )
        SetRunSprintMultiplierForPlayer(PlayerId(), speedrun and 1.49 or 1.0)
    end
)

RegisterAdminNUICallback(
    'Godmode',
    function()
        god = not god
        SendNUIMessage(
            {
                action = 'alert',
                msg = god and 'Godmode: bekapcsolva' or 'Godmode: kikapcsolva',
                color = god and 'success' or 'danger'
            }
        )
        SetPlayerInvincible(PlayerId(), god)
    end
)

RegisterAdminNUICallback(
    'SuperJump',
    function()
        CreateThread(
            function()
                superjump = not superjump
                SendNUIMessage(
                    {
                        action = 'alert',
                        msg = superjump and 'SuperJump: bekapcsolva' or 'SuperJump: kikapcsolva',
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

RegisterAdminNUICallback(
    'Invisible',
    function()
        invisible = not invisible
        SetEntityVisible(PlayerPedId(), not invisible)
        SendNUIMessage(
            {
                action = 'alert',
                msg = invisible and 'Invisible: bekapcsolva' or 'Invisible: kikapcsolva',
                color = invisible and 'success' or 'danger'
            }
        )
    end
)

RegisterAdminNUICallback(
    'Duty',
    function(_, cb)
        ESX.TriggerServerCallback('changePlayerDutyState', function(newState, timeOnDuty)
            SendNUIMessage(
                {
                    action = 'alert',
                    msg = newState and 'Beléptél az Admin szolgálatba' or 'Kiléptél az Admin szolgálatból\nSzolgálatban töltött idő: ' .. timeOnDuty,
                    title = 'Adminszolgálat',
                    color = newState and 'success' or 'danger'
                }
            )

            cb({newState = newState})
        end)
    end
)


RegisterAdminNUICallback(
    'CopyCoords',
    function(data, cb)
        local playerPed = PlayerPedId()
        local posX, posY, posZ = table.unpack(GetEntityCoords(playerPed))

        cb({position = posX .. ', ' .. posY .. ', ' .. posZ})
    end
)

-- Exports
function isPlayerInAdminduty(player)
    if (not player) then
        return LocalPlayer.state.adminDuty
    end

    return Player(player).state.adminDuty
end
exports('isPlayerInAdminduty', isPlayerInAdminduty)

function getPlayerAdminLabel(player)
    if (not player) then
        return LocalPlayer.state.adminLabel or "Admin"
    end

    return Player(player).state.adminLabel or "Admin"
end
exports('getPlayerAdminLabel', getPlayerAdminLabel)