function getFramework()
    if GetResourceState('qb-core') == 'started' then
    return 'qb'
    elseif GetResourceState('es_extended') == 'started' then
        return 'esx'
    elseif GetResourceState('qbx_core') == 'started' then
        return 'qbox'
    elseif GetResourceState('ox_core') == 'started' then
        return 'ox_core'
    end
end

function getFramework_lib()
    if GetResourceState('qb-core') == 'started' then
    return '^1QB-Core'
    elseif GetResourceState('es_extended') == 'started' then
        return '^3ESX'
    elseif GetResourceState('qbx_core') == 'started' then
        return '^6Qbox'
    elseif GetResourceState('ox_core') == 'started' then
        return '^4OX Core'
    end
end

local resfr = getFramework_lib()

AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
      return
    end
    Citizen.Trace('^2Success: ^3' .. resourceName .. '^2 has successfully loaded!^0\n')
    Citizen.Trace("^5Information:^4 Don't change the resource name. If you change the resource name, the libs exports may not work^0\n")
    if Config.Debug then
        Citizen.Trace("^3[DEBUG] ^6Framework: You're using "..resfr.."^0\n")
    end
  end)

function stopResource(resourceName)
    if GetResourceState(resourceName) == 'started' then
        print('^1Stopping resource: ^2' .. resourceName .. '^0')
        StopResource(resourceName)
    else
        print('^1Error: Resource ^2' .. resourceName .. '^0 ^1is not running!^0')
    end
end

function restartResource(resourceName)
    if GetResourceState(resourceName) == 'started' then
        print('^Restarting resource: ^2' .. resourceName .. '^0')
        StopResource(resourceName)
        StartResource(resourceName)
    else
        print('^1Error: Resource ^2' .. resourceName .. '^0 ^1is not running!^0')
    end
end

function startResource(resourceName)
    if GetResourceState(resourceName) == 'stopped' then
        print('^Starting resource: ^2' .. resourceName .. '^0')
        StartResource(resourceName)
    else
        print('^1Error: Resource ^2' .. resourceName .. '^0 ^1is already running!^0')
    end
end
local InstructionalMenus = {}

function RegisterInstructionalMenu(name)
    if InstructionalMenus[name] then return end
    InstructionalMenus[name] = {
        buttons = {},
        autoButtonCount = 0,
        scaleformHandle = nil
    }
end

function AddInstructionalMenuButton(name, text, icon, position, callback)
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
        local selectPressed = false
        while not selectPressed do
            Wait(0)
            DrawScaleformMovieFullscreen(menu.scaleformHandle, 255, 255, 255, 255, 1)
            if IsControlJustReleased(2, 201) then
                selectPressed = true
                local selectedButton = menu.buttons[1]
                for _, button in ipairs(menu.buttons) do
                    if button.position == 0 then
                        selectedButton = button
                        break
                    end
                end
                if selectedButton.callback then
                    selectedButton.callback()
                end
            end
        end
        SetScaleformMovieAsNoLongerNeeded(menu.scaleformHandle)
    end)
end

local NotificationHandles = {}

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

Citizen.CreateThread(function()
    Citizen.Wait(0)
    while true do
        if Config.Tests.disableall == false or Config.Tests.notitest then
            Wait(1000)
            RegisterCommand("notification", function(source, args, rawCommand)
                local text = args[1]
                showNotificationToPlayer(5000, 'blue', text, 'fas fa-info')
            end, false)
        end
        Wait(1000)
    end
end)


function showNotificationToPlayer(duration, color, message, icon)
    SendNUIMessage({
        action = "showNotification",
        duration = duration,
        color = color,
        message = message,
        icon = icon
    })
end

