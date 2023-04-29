-- Tabletop Simulator Connector for D&D Combat Assistant
-- Made by Benjamin Kim & Joshua Haynes, April 2023

-- Network constants:

IP_ADDRESS = nil
PORT = "9001"

GET_INITIATIVE_PATH = "/playermenu/getinitiative"
ROLL_INITIATIVE_PATH = "/playermenu/rollinitiative"
GET_PCS_PATH = "/playermenu/getpcs"
ADD_TO_MAP_PATH = "/playermenu/movetomap"

-- XML ids:

changeIPAddressID = "change_ipaddress"
inputIPAddressID = "ipaddress_input"
pcListID = "pc_list"
textButtonID = "text_button"
requestInitiativeID = "requestInit"
blueInitiativeID = "blueInitiative"
purpleInitiativeID = "purpleInitiative"
greenInitiativeID = "greenInitiative"
orangeInitiativeID = "orangeInitiative"
tealInitiativeID = "tealInitiative"
brownInitiativeID = "brownInitiative"
pinkInitiativeID = "pinkInitiative"
redInitiativeID = "redInitiative"
yellowInitiativeID = "yellowInitiative"
whiteInitiativeID = "whiteInitiative"
gmInitiativeID = "gm_roll_initiative"
gmInitTextID = "text_button_2"

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
BUTTON_COLOR_12 = "#bdbdbd"
ATTRIBUTES = "attributes"
ID = "id"
CHILDREN = "children"

-- Game variables:

characters = {"Sam", "Frodo", "Bilbo", "Gandalf", "Saruman"} -- to remove!
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
    -- for each PC, activate a button (max 10 PCs)
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

function displayTurnOrder(initiativeList)
    broadcastToAll(initiativeList)
end

function getElementByIdFromRoot(root, id)
    for _,childTable in pairs(root) do
        local table = childTable
        local foundElement = getElementById(table, id)
        if foundElement != nil then 
            return foundElement
        end
    end
    return nil
end

function getElementById(xmlTable, id)
    local parentTable = xmlTable

    if parentTable[ATTRIBUTES] != nil and parentTable[ATTRIBUTES][ID] != nil and parentTable[ATTRIBUTES][ID] == id then
        return parentTable

    else
            if type(parentTable[CHILDREN]) == "table" then
                for _, childTable in pairs(parentTable[CHILDREN]) do
                    parentTable = childTable
                    local foundElement = getElementById(parentTable,id)
                    if foundElement != nil then
                        return foundElement
                    end
                end  
            end

    end

    return nil
end

function buildInitiativeRow()

local gottenElement = getElementByIdFromRoot(UI.getXmlTable() , "nestedInnerPanelLeft")

broadcastToAll(gottenElement[ATTRIBUTES][ID])
    --we have to locate the xml element that will contain 

    for _, characterName in ipairs(characters) do
        broadcastToAll(characterName)
    end
end

function requestInitiative()
    numberInitspopulated = 0
    initNameList = ""
    initListForDisplay = ""
    initNamesJsonString = ""
    broadcastToAll("It\'s time to roll initiative!")
    -- for each color, if a PC, activate that UI element to request init
    if isNotEmpty(playerColorMap.White) then
        UI.setAttribute(whiteInitiativeID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Red) then
        UI.setAttribute(redInitiativeID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Orange) then
        UI.setAttribute(orangeInitiativeID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Brown) then
        UI.setAttribute(brownInitiativeID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Pink) then
        UI.setAttribute(pinkInitiativeID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Purple) then
        UI.setAttribute(purpleInitiativeID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Yellow) then
        UI.setAttribute(yellowInitiativeID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Blue) then
        UI.setAttribute(blueInitiativeID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Green) then
        UI.setAttribute(greenInitiativeID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Teal) then
        UI.setAttribute(tealInitiativeID, "active", "true")
    end
    -- now hide the button
    UI.setAttribute(requestInitiativeID, "active", "false")
end

function addPlayerInitiative(player, initTotal, id)
    UI.setAttribute(id, "active", "false")
    -- when entered, populates DM's init popup
    -- find player name
    if player.color == "Purple" then
        playerName = playerColorMap.Purple
    else
        if player.color == "Red" then
            playerName = playerColorMap.Red
        else
            if player.color == "Blue" then
                playerName = playerColorMap.Blue
            else
                if player.color == "Orange" then
                    playerName = playerColorMap.Orange
                else
                    if player.color == "Green" then
                        playerName = playerColorMap.Green
                    else
                        if player.color == "Brown" then
                            playerName = playerColorMap.Brown
                        else
                            if player.color == "Yellow" then
                                playerName = playerColorMap.Yellow
                            else
                                if player.color == "Teal" then
                                    playerName = playerColorMap.Teal
                                else
                                    if player.color == "White" then
                                        playerName = playerColorMap.White
                                    else
                                        if player.color == "Pink" then
                                            playerName = playerColorMap.Pink
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
    print("player name: " .. playerName)
    addNameToGMPopup(playerName, initTotal)
end

function addNameToGMPopup(pName, initiativeTotal)
        initNameList = initNameList..pName..":"..initiativeTotal..", "
        initListForDisplay = "{" .. string.sub(initNameList, 1, string.len(initNameList)-2) .. "}"

        UI.setAttribute(gmInitTextID, "active", "true")
        UI.setAttribute(gmInitTextID, "text", initListForDisplay)

        initNamesJsonString = initNamesJsonString.."\""..pName.."\":\""..initiativeTotal.."\", "
        initNamesJsonStringToSend = "{" .. string.sub(initNamesJsonString, 1, string.len(initNamesJsonString)-2) .. "}"
        print("initNamesJsonStringToSend: "..initNamesJsonStringToSend)

        UI.setAttribute(gmInitiativeID, "active", "true")
        UI.setAttribute(gmInitiativeID, "color", SELECTED_GREY)

        numberInitspopulated = numberInitspopulated + 1
        if numberInitspopulated == numberOfPCs then
            UI.setAttribute(gmInitiativeID, "color", DEFAULT_RED_PINK)
        end
end

function rollGmInitiative()
    UI.setAttribute(gmInitTextID, "active", "false")
    UI.setAttribute(gmInitiativeID, "active", "false")
    broadcastToAll("Rolling npcs...")
    apiRollInit()
    UI.setAttribute(requestInitiativeID, "active", "true")
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

    if foundNames == numberOfPCs then -- close the PC selector
        closePcSelector()
        UI.setAttribute(requestInitiativeID, "active", "true")
    end -- remove test comment
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
        -- else
            -- print(request.text);
        end
    end)
end

function apiRollInit()
    url = "http://" .. IP_ADDRESS .. ":" .. PORT .. ROLL_INITIATIVE_PATH
    -- print("url: " .. url)
    WebRequest.post(url, initNamesJsonStringToSend, function(request)
        if request.is_error then
            print("error: " .. request.error)
            log(request.error)
        else
            displayTurnOrder(request.text);
        end
    end)
end

function apiGetInit()
    url = "http://" .. IP_ADDRESS .. ":" .. PORT .. GET_INITIATIVE_PATH
    -- print("url: " .. url)
    WebRequest.get(url, function(request)
        if request.is_error then
            print("error: " .. request.error)
            log(request.error)
        else
            displayTurnOrder(request.text);
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

function isNotEmpty(s)
    return s ~= nil and s ~= ''
end

-- User interface:

-- 0) spawn in object / code for GUI from workshop
-- 1) GM ONLY - enter the server's exteral ip address (safer not to automate this)
-- 2) display list of PCs (in the future, we can let players add characters and maybe even pictures)
-- 3) Players - choose your player. asscociated with your tabletop color (when a player is selected, add to map).
-- 4) GM ONLY - 'request initiative' button. asks each player for their initiaitve total. 
-- 5) Players - enter your initiative total (GM should already have your dex in the server in case of ties). 
--   5.5) Once all player initiative totals are collected, GM can roll init (display what is entered to the GM).

-- 6) Display turn order
-- 7) On a player's turn, they can end their turn, advancing to the next player ('your turn' notification?).
--   7.5) GM can end any turn.
-- 8) GM can also refresh turn order

-- future: add funtion to 'reveal' enemy attacks, weakneses or reactions!
-- how to tie to object??
