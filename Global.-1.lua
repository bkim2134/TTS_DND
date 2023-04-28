-- Tabletop Simulator Connector for D&D Combat Assistant
-- Made by Benjamin Kim & Joshua Haynes, April 2023

-- Network constants:

IP_ADDRESS = nil
PORT = "9001"

GET_INITIATIVE_PATH = "/playermenu/getinitiative"
GET_PCS_PATH = "/playermenu/getpcs"
ADD_TO_MAP_PATH = "/playermenu/movetomap"

-- XML ids:

changeIPAddressID = "change_ipaddress"
inputIPAddressID = "ipaddress_input"
pcListID = "pc_list"
textButtonID = "text_button"
requestInitiativeID = "requestInit"

-- Core functions:

function onLoad()
    --[[ print('onLoad!') --]]
end

function onUpdate()
    --[[ print('onUpdate loop!') --]]
end

-- Game constants:

SELECTED_GREY = "#787878"
DEFAULT_RED_PINK = "#ff6666"
DEFAULTY_GREY = "#d1d1d1"
BUTTON_COLOR_1 = "#99ccff"
BUTTON_COLOR_2 = "#3399ff"
BUTTON_COLOR_3 = "#ff99ff"
BUTTON_COLOR_4 = "#cc99ff"
BUTTON_COLOR_5 = "#ff0066"
BUTTON_COLOR_6 = "#cc0000"
BUTTON_COLOR_7 = "#ffcc99"
BUTTON_COLOR_8 = "#e48b07"
BUTTON_COLOR_9 = "#00ffcc"
BUTTON_COLOR_10 = "#009933"
BUTTON_COLOR_11 = "#ebebeb"
BUTTON_COLOR_12 = "#bdbdbd" -- can the .xml file refer to these constants?

-- Game variables:

playerColorMap = {White = "", Red = "", Brown = "", Orange = "", Yellow = "", Green = "", Teal = "", Blue = "", Purple = "", Pink = ""}

-- Network functions:

function storeIPAddress(player, ipAddress, id)
    IP_ADDRESS = ipAddress
    -- print("The current IP Address is: " .. ipAddress)
    UI.setAttribute(changeIPAddressID, "active", "true")
    UI.setAttribute(changeIPAddressID, "visibility", "host")
    UI.setAttribute(inputIPAddressID, "active", "false")
    UI.setAttribute(changeIPAddressID, "text",IP_ADDRESS)
    loadPlayerData()
end

function changeIPAddress()
    UI.setAttribute(inputIPAddressID, "active", "true")
    UI.setAttribute(inputIPAddressID, "visibility", "host")
    UI.setAttribute(changeIPAddressID, "active", "false")
end

-- UI functions:

function displayPcs(pcList)
    -- for each PC, activate a button (max 12 PCs)
    pcListList = mysplit(shaveString(pcList), ",")
    numberOfPCs = #(pcListList)

    for i = 1, numberOfPCs, 1 do
        -- print(pcListList[i])
        name = shaveString(pcListList[i])
        buttonId = "buttonId" .. tostring(i)
        UI.setAttribute(buttonId, "active", "true")
        UI.setAttribute(buttonId, "text", name)
        UI.setAttribute(buttonId, "onClick", "playerSelected("..name..")")
    end

    UI.setAttribute(textButtonID, "active", "true")
    UI.setAttribute(pcListID, "active", "true")
end

function displayTurnOrder()
end

function requestInitiative()
    broadcastToAll("It\'s time to roll initiative!")
end

function playerSelected(player, name, id)
    print(player.steam_name .. " (" .. player.color .. ") selected: " .. name)
    -- id is the buttonId

    playerColorMap[tostring(player.color)] = name
    UI.setAttribute(id, "color", SELECTED_GREY)

    addToMap(name) -- API call, add character to map

    checkIfAllPCsSelected() -- close the PC selector if all are chosen
end

function checkIfAllPCsSelected()
    -- for each PC, check if it is assigned to a color
    foundNames = 0
    for k = 1, numberOfPCs, 1 do
        name = shaveString(pcListList[k])
        -- print(name)
        -- print("White: " .. playerColorMap.White)
        -- print("Blue: " .. playerColorMap.Blue)
        -- print("Red: " .. playerColorMap.Red)
        -- print("Orange: " .. playerColorMap.Orange)
        -- print("Teal: " .. playerColorMap.Teal)
        -- print("Pink: " .. playerColorMap.Pink)
        -- print("Brown: " .. playerColorMap.Brown)
        -- print("Yellow: " .. playerColorMap.Yellow)
        -- print("Purple: " .. playerColorMap.Purple)
        -- print("Green: " .. playerColorMap.Green)

        if playerColorMap.White == name or playerColorMap.Red == name or playerColorMap.Brown == name or playerColorMap.Orange == name or playerColorMap.Yellow == name or playerColorMap.Green == name or playerColorMap.Teal == name or playerColorMap.Blue == name or playerColorMap.Purple == name or playerColorMap.Pink == name then
            foundNames = foundNames + 1 
        end
        
    end

    -- if foundNames == numberOfPCs then -- close the PC selector
        closePcSelector()
        UI.setAttribute(requestInitiativeID, "active", "true")
    -- end
end

function closePcSelector()
    UI.setAttribute(textButtonID, "active", "false")
    UI.setAttribute(pcListID, "active", "false")
    for m = 1, 12, 1 do -- set buttons to inactive & reset color
        setColor = DEFAULT_RED_PINK
        if m == 1 then
            setColor = BUTTON_COLOR_1
        else 
            if m == 2 then
                setColor = BUTTON_COLOR_2
            else
                if m == 3 then
                    setColor = BUTTON_COLOR_3
                else
                    if m == 4 then
                        setColor = BUTTON_COLOR_4
                    else
                        if m == 5 then
                            setColor = BUTTON_COLOR_5
                        else
                            if m == 6 then
                                setColor = BUTTON_COLOR_6
                            else
                                if m == 7 then
                                    setColor = BUTTON_COLOR_7
                                else
                                    if m == 8 then
                                        setColor = BUTTON_COLOR_8
                                    else
                                        if m == 9 then
                                            setColor = BUTTON_COLOR_9
                                        else
                                            if m == 10 then
                                                setColor = BUTTON_COLOR_10
                                            else
                                                if m == 11 then
                                                    setColor = BUTTON_COLOR_11
                                                else
                                                    if m == 12 then
                                                        setColor = BUTTON_COLOR_12
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        buttonId = "buttonId" .. tostring(m)
        UI.setAttribute(buttonId, "color", setColor)
        UI.setAttribute(buttonId, "active", "false")
    end
end

-- API functions:

function loadPlayerData()
    url = "http://" .. IP_ADDRESS .. ":" .. PORT .. GET_PCS_PATH
    -- print("url: " .. url)
    WebRequest.get(url, function(request)
        if request.is_error then
            print("error: " .. request.error)
            log(request.error)
        else
            displayPcs(request.text);
        end
    end)
    
end

function addToMap(name)
    url = "http://" .. IP_ADDRESS .. ":" .. PORT .. ADD_TO_MAP_PATH
    -- print("url: " .. url)
    -- print(name)
    WebRequest.post(url, name, function(request)
        if request.is_error then
            print("error: " .. request.error)
            log(request.error)
        else
            -- print(request.text);
        end
    end)

end

-- Utility functions:

function shaveString(inputstr)
    return string.sub(inputstr, 2, string.len(inputstr)-1)
end

function mysplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

-- User interface:

-- 0) spawn in object / code for GUI from workshop
-- 1) GM ONLY - enter the server's exteral ip address (safer not to automate this)
-- 2) display list of PCs (in the future, we can let players add characters and maybe even pictures)
-- 3) Players - choose your player. asscociated with your tabletop color (when a player is selected, add to map).
-- 4) GM ONLY - 'request initiative' button. asks each player for their initiaitve total. 
-- 5) Players - enter your initiative total (GM should already have your dex in the server in case of ties). 
--   5.5) Once all player initiative totals are collected, GM can roll init (display what is entered to the GM).
-- 6) Display live turn order (updatable by the GM via the server)
-- 7) On a player's turn, they can end their turn, advancing to the next player ('your turn' notification?).
--   7.5) GM can end any turn.

-- future: add funtion to 'reveal' enemy attacks, weakneses or reactions!