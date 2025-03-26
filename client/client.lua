function debugPrint(msg)
    if Config.Debug then
        print(string.format('^3[DEBUG] ^7%s^0', msg))
    end
end

function getFramework()
    if GetResourceState('qb-core') == 'started' then
    return 'qb', '^1QB-Core'
    elseif GetResourceState('es_extended') == 'started' then
        return 'esx', '^3ESX'
    elseif GetResourceState('qbx_core') == 'started' then
        return 'qbox', '^6Qbox'
    elseif GetResourceState('ox_core') == 'started' then
        return 'ox_core', '^4OX Core'
    end

    return 'IDK', 'IDK'
end

AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
      return
    end

    local _, frameworkLabel = getFramework()
    print(string.format('^2Success: ^3%s^2 has successfully loaded! ^0', resourceName))
    debugPrint(string.format('^6Framework: You are using %s^0', frameworkLabel))
end)

local InstructionalMenus = {}

function RegisterInstructionalMenu(name)
    if InstructionalMenus[name] then return end
    InstructionalMenus[name] = {
        buttons = {},
        autoButtonCount = 0,
        scaleformHandle = nil
    }
end

function AddInstructionalMenuButton(name, text, icon, position, control, callback)
    if not InstructionalMenus[name] then return end
    local menu = InstructionalMenus[name]
    if not position then
        position = menu.autoButtonCount
        menu.autoButtonCount = menu.autoButtonCount + 1
    end
    table.insert(menu.buttons, {
        position = position,
        text = text,
        icon = icon,
        control = control,
        callback = callback
    })
end

function UnregisterInstructionalMenuButton(name, position)
    if not InstructionalMenus[name] then return end
    local menu = InstructionalMenus[name]
    for i, button in ipairs(menu.buttons) do
        if button.position == position then
            table.remove(menu.buttons, i)
            break
        end
    end
end

function UnregisterInstructionalMenu(name)
    if not InstructionalMenus[name] then return end
    InstructionalMenus[name] = nil
end

function ShowInstructionalMenu(name)
    if not InstructionalMenus[name] then return end
    local menu = InstructionalMenus[name]
    CreateThread(function()
        menu.scaleformHandle = RequestScaleformMovie('INSTRUCTIONAL_BUTTONS')
        while not HasScaleformMovieLoaded(menu.scaleformHandle) do
            Wait(0)
        end
        CallScaleformMovieMethod(menu.scaleformHandle, 'CLEAR_ALL')
        CallScaleformMovieMethodWithNumber(menu.scaleformHandle, 'TOGGLE_MOUSE_BUTTONS', 0)
        for _, button in ipairs(menu.buttons) do
            BeginScaleformMovieMethod(menu.scaleformHandle, 'SET_DATA_SLOT')
            ScaleformMovieMethodAddParamInt(button.position)
            if button.icon then
                ScaleformMovieMethodAddParamTextureNameString('~' .. button.icon .. '~')
            end
            ScaleformMovieMethodAddParamPlayerNameString(button.text)
            EndScaleformMovieMethod()
        end
        CallScaleformMovieMethod(menu.scaleformHandle, 'DRAW_INSTRUCTIONAL_BUTTONS')

        local buttonPressed = false
        while not buttonPressed do
            Wait(0)
            DrawScaleformMovieFullscreen(menu.scaleformHandle, 255, 255, 255, 255, 1)

            for _, button in ipairs(menu.buttons) do
                if IsControlJustReleased(2, button.control) then
                    if button.callback then
                        button.callback()
                    end
                    buttonPressed = true
                    break
                end
            end
        end

        SetScaleformMovieAsNoLongerNeeded(menu.scaleformHandle)
    end)
end

function ShowNotificationMenu(text, duration)
    local duration = duration or 5000
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    local notificationId = DrawNotification(false, true)
    Citizen.SetTimeout(duration, function()
        RemoveNotification(notificationId)
    end)
end

if not Config.Tests.disableall or Config.Tests.notitest then
    RegisterCommand("notification", function(source, args, rawCommand)
        local text = args[1]
        showNotificationToPlayer(5000, 'blue', text, 'fas fa-info')
    end)
end

function showNotificationToPlayer(duration, color, message, icon)
    SendNUIMessage({
        action = "showNotification",
        duration = duration,
        color = color,
        message = message,
        icon = icon
    })
end

AddEventHandler('onResourceStart', function (resName)
    if resName ~= GetCurrentResourceName() or GetCurrentResourceName() == 'rxn_lib' then
        return
    end

    for i = 0, 10 do
        print('^2This script has to be named rxn_lib in order for it to work!!^0')
        Wait(100)
    end
end)
