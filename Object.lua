-- Object.lua: 
-- 1) Copy the code below into the object's lua in the scripting editor.
-- 2) Add c8645d/ to the button onlick attributes in displayPcs()
-- 3) Save the object.
-- 4) When you load in the object, it will load the D&D Combat Assistant.
-- The main difference is that the global UI is set to XML_STRING on load.


-- Tabletop Simulator Connector for D&D Combat Assistant
-- Made by Benjamin Kim & Joshua Haynes, April 2023


-- XML constant: 

XML_STRING = [[
<Panel id = "superPanel">
    <Panel id = "ipSelectorPanel" position = "590 516 0">
        <InputField id = "ipaddress_input" visibility = "host" onEndEdit = "c8645d/storeIPAddress"  placeholder = "Input server address:" allowDragging = "true" returnToOriginalPositionWhenReleased = "false"></InputField>
        <Button id = "change_ipaddress" visibility = "host" active = "false" onClick="c8645d/changeIPAddress" width = "160" height = "30" allowDragging = "true" returnToOriginalPositionWhenReleased = "false">Change server address</Button>
    </Panel>

    <Panel id = "playerSelectorPanel">
        <Button id = "text_button" position = "0 330 0" width = "700" height = "32" colors = "#d1d1d1|#d1d1d1|#d1d1d1|#d1d1d1" fontStyle = "bold" fontSize = "16px" active = "false">Choose a character:</Button>
        <GridLayout id = "pc_list" childAlignment = "upperCenter" padding = "250 250 250 250" spacing = "20 10" cellSize = "300 75" active = "false">
            <Button id = "buttonId1" onClick = "c8645d/playerSelected(Button One)" color = "#99ccff" fontStyle = "bold" fontSize = "16px" active = "false">Button One</Button>
            <Button id = "buttonId2" onClick = "c8645d/playerSelected(Button Two)" color = "#3399ff" fontStyle = "bold" fontSize = "16px" active = "false">Button Two</Button>
            <Button id = "buttonId3" onClick = "c8645d/playerSelected(Button Three)" color = "#ff99ff" fontStyle = "bold" fontSize = "16px" active = "false">Button Three</Button>
            <Button id = "buttonId4" onClick = "c8645d/playerSelected(Button Four)" color = "#cc99ff" fontStyle = "bold" fontSize = "16px" active = "false">Button Four</Button>
            <Button id = "buttonId5" onClick = "c8645d/playerSelected(Button Five)" color = "#ff0066" fontStyle = "bold" fontSize = "16px" active = "false">Button Five</Button>
            <Button id = "buttonId6" onClick = "c8645d/playerSelected(Button Six)" color = "#cc0000" fontStyle = "bold" fontSize = "16px" active = "false">Button Six</Button>
            <Button id = "buttonId7" onClick = "c8645d/playerSelected(Button Seven)" color = "#ffcc99" fontStyle = "bold" fontSize = "16px" active = "false">Button Seven</Button>
            <Button id = "buttonId8" onClick = "c8645d/playerSelected(Button Eight)" color = "#e48b07" fontStyle = "bold" fontSize = "16px" active = "false">Button Eight</Button>
            <Button id = "buttonId9" onClick = "c8645d/playerSelected(Button Nine)" color = "#00ffcc" fontStyle = "bold" fontSize = "16px" active = "false">Button Nine</Button>
            <Button id = "buttonId10" onClick = "c8645d/playerSelected(Button Ten)" color = "#009933" fontStyle = "bold" fontSize = "16px" active = "false">Button Ten</Button>
            <Button id = "buttonId11" onClick = "c8645d/playerSelected(Button Eleven)" color = "#ebebeb" fontStyle = "bold" fontSize = "16px" active = "false">Button Eleven</Button>
            <Button id = "buttonId12" onClick = "c8645d/playerSelected(Button Twelve)" color = "#bdbdbd" fontStyle = "bold" fontSize = "16px" active = "false">Button Twelve</Button>
        </GridLayout>
        <Button id = "addAPlayer" visibility = "host" color = "#3498DB" onClick="c8645d/displayPcs" position = "870 250 0" width = "160" height = "30" active = "false" allowDragging = "true" returnToOriginalPositionWhenReleased = "false">Open Player Selector</Button>
        <Button id = "closePlayerSelector" visibility = "host" color = "#cc0000" onClick="c8645d/closePcSelector" position = "870 210 0" width = "160" height = "30" active = "false" allowDragging = "true" returnToOriginalPositionWhenReleased = "false">Close Player Selector</Button>
    </Panel>

    <Panel id = "initiativePanel">
        <Button id = "requestInit" visibility = "host" allowDragging = "true" returnToOriginalPositionWhenReleased = "false" active = "false" onClick="c8645d/requestInitiative" position = "850 150 0" width = "200" height = "60" color = "#ff6666" fontStyle = "bold" fontSize = "16px">Request Initiatve</Button>
        <InputField id = "blueInitiative" visibility = "blue" allowDragging = "true" active = "false" returnToOriginalPositionWhenReleased = "false" onEndEdit = "c8645d/addPlayerInitiative" position = "0 0 0" placeholder = "Enter initiative total:"></InputField>
        <InputField id = "purpleInitiative" visibility = "purple" allowDragging = "true" active = "false" returnToOriginalPositionWhenReleased = "false" onEndEdit = "c8645d/addPlayerInitiative" position = "0 0 0" placeholder = "Enter initiative total:"></InputField>
        <InputField id = "greenInitiative" visibility = "green" onEndEdit = "c8645d/addPlayerInitiative" active = "false" allowDragging = "true" returnToOriginalPositionWhenReleased = "false" position = "0 0 0" placeholder = "Enter initiative total:"></InputField>
        <InputField id = "orangeInitiative" visibility = "orange" onEndEdit = "c8645d/addPlayerInitiative" active = "false" allowDragging = "true" returnToOriginalPositionWhenReleased = "false" position = "0 0 0" placeholder = "Enter initiative total:"></InputField>
        <InputField id = "tealInitiative" visibility = "teal" onEndEdit = "c8645d/addPlayerInitiative" active = "false" allowDragging = "true" returnToOriginalPositionWhenReleased = "false" position = "0 0 0" placeholder = "Enter initiative total:"></InputField>
        <InputField id = "brownInitiative" visibility = "brown" onEndEdit = "c8645d/addPlayerInitiative" active = "false" allowDragging = "true" returnToOriginalPositionWhenReleased = "false" position = "0 0 0" placeholder = "Enter initiative total:"></InputField>
        <InputField id = "pinkInitiative" visibility = "pink" onEndEdit = "c8645d/addPlayerInitiative" active = "false" allowDragging = "true" returnToOriginalPositionWhenReleased = "false" position = "0 0 0" placeholder = "Enter initiative total:"></InputField>
        <InputField id = "redInitiative" visibility = "red" onEndEdit = "c8645d/addPlayerInitiative" active = "false" allowDragging = "true" returnToOriginalPositionWhenReleased = "false" position = "0 0 0" placeholder = "Enter initiative total:"></InputField>
        <InputField id = "yellowInitiative" visibility = "yellow" onEndEdit = "c8645d/addPlayerInitiative" active = "false" allowDragging = "true" returnToOriginalPositionWhenReleased = "false" position = "0 0 0" placeholder = "Enter initiative total:"></InputField>
        <InputField id = "whiteInitiative" visibility = "white" onEndEdit = "c8645d/addPlayerInitiative" active = "false" allowDragging = "true" returnToOriginalPositionWhenReleased = "false" position = "0 0 0" placeholder = "Enter initiative total:"></InputField>
    </Panel>

    <Panel id = "gmInitPanel">
        <Button id = "text_button_2" visibility = "host" position = "650 -430 0" width = "600" height = "80" colors = "#d1d1d1|#d1d1d1|#d1d1d1|#d1d1d1" fontStyle = "bold" fontSize = "16px" active = "false" allowDragging = "true" returnToOriginalPositionWhenReleased = "false">GM initiative list here</Button>
        <Button id = "gm_roll_initiative" visibility = "host" position = "655 -500 0" width = "200" height = "50" color = "#3498DB" fontStyle = "bold" fontSize = "16px" active = "false" onClick = "c8645d/rollGmInitiative" allowDragging = "true" returnToOriginalPositionWhenReleased = "false">Roll new initiative!</Button>
    </Panel>

    <Panel id = "turnPanel">
        <Button id = "text_button_3" position = "-450 400 0" width = "350" height = "40" fontStyle = "bold" fontSize = "16px" active = "false" allowDragging = "true" returnToOriginalPositionWhenReleased = "false" color = "#ffcc00">Current turn: here</Button>
        <Button id = "text_button_4" position = "450 400 0" width = "350" height = "40" fontStyle = "bold" fontSize = "16px" active = "false" allowDragging = "true" returnToOriginalPositionWhenReleased = "false" color = "#9900cc">Next turn: here</Button>
        <Button id = "end_turn_button" position = "0 -400 0" width = "200" height = "60" color = "#ff6666" fontStyle = "bold" fontSize = "16px" active = "false" allowDragging = "true" returnToOriginalPositionWhenReleased = "false" onClick = "apiEndTurn">End Turn</Button>
        <Button id = "end_turn_gm" visibility = "host" position = "850 0 0" width = "200" height = "60" color = "#ff6666" fontStyle = "bold" fontSize = "16px" active = "false" allowDragging = "true" returnToOriginalPositionWhenReleased = "false" onClick = "c8645d/apiEndTurn">End Current Turn</Button>
        <Button id = "end_combat_gm" visibility = "host" position = "850 -75 0" width = "200" height = "60" color = "#cc0000" fontStyle = "bold" fontSize = "16px" active = "false" allowDragging = "true" returnToOriginalPositionWhenReleased = "false" onClick = "c8645d/endCombat">End Combat</Button>
        <Button id = "refresh_combat_gm" visibility = "host" position = "850 75 0" width = "200" height = "60" color = "#339933" fontStyle = "bold" fontSize = "16px" active = "false" allowDragging = "true" returnToOriginalPositionWhenReleased = "false" onClick = "c8645d/apiGetInit">Refresh Current Players</Button>
    </Panel>
</Panel>
]]

-- Network constants:

IP_ADDRESS = nil
PORT = "9001"

GET_INITIATIVE_PATH = "/playermenu/getinitiative"
ROLL_INITIATIVE_PATH = "/playermenu/rollinitiative"
GET_PCS_PATH = "/playermenu/getpcs"
ADD_TO_MAP_PATH = "/playermenu/movetomap"
NEXT_TURN_PATH = "/playermenu/nextturn"
GET_CURRENT_PLAYER_PATH = "/playermenu/getcurrentcharacter"
GET_NEXT_PLAYER_PATH = "/playermenu/getnextcharacter"

-- XML id constants:

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
turnOrderID = "h_scrollView"
currentPlayerID = "text_button_3"
nextPlayerID = "text_button_4"
endTurnID = "end_turn_button"
endTurnGmID = "end_turn_gm"
endCombatID = "end_combat_gm"
refreshCombatID = "refresh_combat_gm"
addAPlayerID = "addAPlayer"
closePlayerSelectorID = "closePlayerSelector"

-- Game constants:

SELECTED_GREY = "#787878"
PROMPT_BLUE = "#3498DB"
NPC_PURPLE = "#9B59B6"
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
-- ATTRIBUTES = "attributes"
-- ID = "id"
-- CHILDREN = "children"
CR_STRING = "CR "

-- Game variables:

pcList = {}
numberOfPCs = 0
playerColorMap = {White = "", Red = "", Brown = "", Orange = "", Yellow = "", Green = "", Teal = "", Blue = "", Purple = "", Pink = ""}
currentTurnName = ""
nextTurnName = ""
pcSelectorActive = false

-- Core functions:

function onLoad()
    broadcastToAll("Loading the D&D Combat Assistant...")
    -- print(XML_STRING)
    UI.setXml(XML_STRING)
end

function onUpdate()
    -- print('onUpdate loop!')
end

-- Network setup functions:

function storeIPAddress(player, ipAddress, id)
    IP_ADDRESS = ipAddress
    -- print("The current IP Address is: " .. ipAddress)
    UI.setAttribute(changeIPAddressID, "active", "true")
    UI.setAttribute(changeIPAddressID, "visibility", "host")
    UI.setAttribute(inputIPAddressID, "active", "false")
    UI.setAttribute(changeIPAddressID, "text", IP_ADDRESS)
    loadPlayerData()
end

function changeIPAddress()
    UI.setAttribute(inputIPAddressID, "active", "true")
    UI.setAttribute(inputIPAddressID, "visibility", "host")
    UI.setAttribute(changeIPAddressID, "active", "false")
end

-- Player selection functions:

function makePcList(pcListFromServer)
    pcList = mysplit(shaveString(pcListFromServer), ",")
    numberOfPCs = #(pcList)
    displayPcs()
    UI.setAttribute(addAPlayerID, "active", "true")
    UI.setAttribute(closePlayerSelectorID, "active", "true")
end

function displayPcs()
    -- for each PC, activate a button (max 10 PCs)
    for i = 1, numberOfPCs, 1 do
        -- print(pcList[i])
        name = shaveString(pcList[i])
        buttonId = "buttonId" .. tostring(i)
        UI.setAttribute(buttonId, "active", "true")
        UI.setAttribute(buttonId, "text", name)
        UI.setAttribute(buttonId, "onClick", "c8645d/playerSelected("..name..")") -- also add c8645d/ here
    end

    UI.setAttribute(textButtonID, "active", "true")
    UI.setAttribute(pcListID, "active", "true")
    pcSelectorActive = true
end

function playerSelected(player, name, id)
    -- id is the buttonId
    playerCurrentName = findPlayerNameFromColor(player.color)
    if playerCurrentName == name then
        broadcastToColor("You've already selected "..name, player.color)
    else
        broadcastToAll(player.steam_name .. " (" .. player.color .. ") selected: " .. name)
        playerColorMap[tostring(player.color)] = name
        updatePlayerButtons()
        apiAddToMap(name)
        UI.setAttribute(requestInitiativeID, "active", "true")
        UI.setAttribute(requestInitiativeID, "color", SELECTED_GREY)
        checkIfAllPCsSelected()
    end
end

function updatePlayerButtons()
    -- set any selected buttons to SELECTED_GREY, all others to default
    for m = 1, 12, 1 do
        buttonId = "buttonId" .. tostring(m)
        playerName02 = UI.getAttribute(buttonId, "text")
        -- print(playerName02)
        setColor = DEFAULT_RED_PINK

        if isPlayerInColorMap(playerName02) then
            setColor = SELECTED_GREY
        else
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
        end

        UI.setAttribute(buttonId, "color", setColor)
    end
end

function checkIfAllPCsSelected()
    -- for each PC, check if it is assigned to a color
    foundNames = 0
    for k = 1, numberOfPCs, 1 do
        name = shaveString(pcList[k])
        -- print(name)
        if isPlayerInColorMap(name) then
            foundNames = foundNames + 1 
        end
    end
    -- print(foundNames)
    if foundNames == numberOfPCs then
        closePcSelector()
        UI.setAttribute(requestInitiativeID, "color", PROMPT_BLUE)
    end
end

function closePcSelector()
    UI.setAttribute(textButtonID, "active", "false")
    UI.setAttribute(pcListID, "active", "false")
    pcSelectorActive = false
end

-- Initiative funtions:

function requestInitiative()
    endCombat()
    if  pcSelectorActive then
        closePcSelector()
    end
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
    UI.setAttribute(requestInitiativeID, "color", SELECTED_GREY)
end

function addPlayerInitiative(player, initTotal, id)
    UI.setAttribute(id, "active", "false")
    name01 = findPlayerNameFromColor(player.color)
    -- print(name01)
    addNameToGMPopup(name01, initTotal)
end

function addNameToGMPopup(pName, initiativeTotal)
        initNameList = initNameList..pName..":"..initiativeTotal..", "
        initListForDisplay = "{" .. string.sub(initNameList, 1, string.len(initNameList)-2) .. "}"

        UI.setAttribute(gmInitTextID, "active", "true")
        UI.setAttribute(gmInitTextID, "text", initListForDisplay)

        initNamesJsonString = initNamesJsonString.."\""..pName.."\":\""..initiativeTotal.."\", "
        initNamesJsonStringToSend = "{" .. string.sub(initNamesJsonString, 1, string.len(initNamesJsonString)-2) .. "}"
        -- print("initNamesJsonStringToSend: "..initNamesJsonStringToSend)

        UI.setAttribute(gmInitiativeID, "active", "true")
        UI.setAttribute(gmInitiativeID, "color", SELECTED_GREY)

        numberInitspopulated = numberInitspopulated + 1
        if numberInitspopulated == numberOfPCs then
            UI.setAttribute(gmInitiativeID, "color", PROMPT_BLUE)
        end
end

function rollGmInitiative()
    UI.setAttribute(gmInitTextID, "active", "false")
    UI.setAttribute(gmInitiativeID, "active", "false")
    -- broadcastToAll("Rolling npcs...")
    apiRollInit()
    UI.setAttribute(requestInitiativeID, "color", PROMPT_BLUE)
end

function endCombat()
    UI.setAttribute(endTurnID, "active", "false")
    UI.setAttribute(endTurnGmID, "active", "false")
    UI.setAttribute(endCombatID, "active", "false")
    UI.setAttribute(refreshCombatID, "active", "false")
    UI.setAttribute(currentPlayerID, "active", "false")
    UI.setAttribute(nextPlayerID, "active", "false")
end

-- Turn & time functions:

function announceTurn(currPlayer)
    if isCharacterNpc(currPlayer) then
        currPlayer = cutOutCRtext(currPlayer)
        UI.setAttribute(endTurnGmID, "color", NPC_PURPLE)
    else
        UI.setAttribute(endTurnGmID, "color", DEFAULT_RED_PINK)
    end
    currentTurnName = currPlayer
    broadcastToAll("It\'s your turn, "..currentTurnName.."!")
    UI.setAttribute(currentPlayerID, "active", "true")
    UI.setAttribute(currentPlayerID, "text", "Current Turn: "..currentTurnName)

    noMatch = false
    if playerColorMap.White == currentTurnName then
        UI.setAttribute(endTurnID, "visibility", "white")
    else
        if playerColorMap.Yellow == currentTurnName then
            UI.setAttribute(endTurnID, "visibility", "yellow")
        else
            if playerColorMap.Orange == currentTurnName then
                UI.setAttribute(endTurnID, "visibility", "orange")
            else
                if playerColorMap.Teal == currentTurnName then
                    UI.setAttribute(endTurnID, "visibility", "teal")
                else
                    if playerColorMap.Brown == currentTurnName then
                        UI.setAttribute(endTurnID, "visibility", "brown")
                    else
                        if playerColorMap.Pink == currentTurnName then
                            UI.setAttribute(endTurnID, "visibility", "pink")
                        else
                            if playerColorMap.Purple == currentTurnName then
                                UI.setAttribute(endTurnID, "visibility", "purple")
                            else
                                if playerColorMap.Green == currentTurnName then
                                    UI.setAttribute(endTurnID, "visibility", "green")
                                else
                                    if playerColorMap.Blue == currentTurnName then
                                        UI.setAttribute(endTurnID, "visibility", "blue")
                                    else
                                        if playerColorMap.Red == currentTurnName then
                                            UI.setAttribute(endTurnID, "visibility", "red")
                                        else
                                            noMatch = true
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
    if noMatch then
        UI.setAttribute(endTurnID, "active", "false")
    else
        UI.setAttribute(endTurnID, "active", "true")
    end
end

function setNextTurn(nextPlayer)
    nextPlayer = cutOutCRtext(nextPlayer)
    nextTurnName = nextPlayer
    UI.setAttribute(nextPlayerID, "active", "true")
    UI.setAttribute(nextPlayerID, "text", "Next Turn: "..nextTurnName)
end

function announceTime(currRound)
    print("The current time is: "..currRound)
    displayTurnOrder() -- refresh on end turn
end

function displayTurnOrder()
    -- refresh!
    getCurrentPlayer()
    getNextPlayer()    

    UI.setAttribute(endTurnGmID, "active", "true")
    UI.setAttribute(endCombatID, "active", "true")
    UI.setAttribute(refreshCombatID, "active", "true")
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
            makePcList(request.text);
        end
    end)
end

function apiAddToMap(name)
    url = "http://" .. IP_ADDRESS .. ":" .. PORT .. ADD_TO_MAP_PATH
    -- print("url: " .. url)
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
            displayTurnOrder();
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
            displayTurnOrder();
        end
    end)
    
end

function getCurrentPlayer()
    url = "http://" .. IP_ADDRESS .. ":" .. PORT .. GET_CURRENT_PLAYER_PATH
    -- print("url: " .. url)
    WebRequest.get(url, function(request)
        if request.is_error then
            print("error: " .. request.error)
            log(request.error)
        else
            announceTurn(request.text);
        end
    end)
end

function getNextPlayer()
    url = "http://" .. IP_ADDRESS .. ":" .. PORT .. GET_NEXT_PLAYER_PATH
    -- print("url: " .. url)
    WebRequest.get(url, function(request)
        if request.is_error then
            print("error: " .. request.error)
            log(request.error)
        else
            setNextTurn(request.text);
        end
    end)
end

function apiEndTurn()
    url = "http://" .. IP_ADDRESS .. ":" .. PORT .. NEXT_TURN_PATH
    -- print("url: " .. url)
    WebRequest.get(url, function(request)
        if request.is_error then
            print("error: " .. request.error)
            log(request.error)
        else
            announceTime(request.text);
        end
    end)
end

-- Utility functions:

function findPlayerNameFromColor(playerColor)
    -- find player name
    if playerColor == "Purple" then
        playerName = playerColorMap.Purple
    else
        if playerColor == "Red" then
            playerName = playerColorMap.Red
        else
            if playerColor == "Blue" then
                playerName = playerColorMap.Blue
            else
                if playerColor == "Orange" then
                    playerName = playerColorMap.Orange
                else
                    if playerColor == "Green" then
                        playerName = playerColorMap.Green
                    else
                        if playerColor == "Brown" then
                            playerName = playerColorMap.Brown
                        else
                            if playerColor == "Yellow" then
                                playerName = playerColorMap.Yellow
                            else
                                if playerColor == "Teal" then
                                    playerName = playerColorMap.Teal
                                else
                                    if playerColor == "White" then
                                        playerName = playerColorMap.White
                                    else
                                        if playerColor == "Pink" then
                                            playerName = playerColorMap.Pink
                                        else
                                            playerName = "No name found for color "..playerColor
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
    -- print("player name: " .. playerName)
    return playerName
end

function isPlayerInColorMap(potentialPlayerName)
    return playerColorMap.White == potentialPlayerName or playerColorMap.Red == potentialPlayerName or playerColorMap.Brown == potentialPlayerName or playerColorMap.Orange == potentialPlayerName or playerColorMap.Yellow == potentialPlayerName or playerColorMap.Green == potentialPlayerName or playerColorMap.Teal == potentialPlayerName or playerColorMap.Blue == potentialPlayerName or playerColorMap.Purple == potentialPlayerName or playerColorMap.Pink == potentialPlayerName
end

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

function isCharacterNpc(str)
    if str:find(CR_STRING) then
        return true
    else
        return false
    end
end

function cutOutCRtext(str)
    if str:find(CR_STRING) then
        -- print("CR str: " .. str)
        p, q = str:find(CR_STRING)
        str = string.sub(str, 1, p-3) -- cut off the ( too
        -- print(str)
    end
    return str
end