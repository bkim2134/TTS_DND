-- Tabletop Simulator Connector for D&D Combat Assistant
-- Made by Benjamin Kim & Joshua Haynes, April 2023


-- XML variables: 

isTabletopObject = false -- set to true for objects
XML_STRING = [[
<XML id = "test" onCLick = "guidPlaceholder/foo">
<XML>
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
requestSkillID = "requestPartySkill"
whiteSkillID = "whiteSkill"
blueSkillID = "blueSkill"
greenSkillID = "greenSkill"
yellowSkillID = "yellowSkill"
purpleSkillID = "purpleSkill"
redSkillID = "redSkill"
orangeSkillID = "orangeSkill"
tealSkillID = "tealSkill"
pinkSkillID = "pinkSkill"
brownSkillID = "brownSkill"
skillTextID = "text_button_5"
openPartySkillViewerID = "openPartySkillViewer"

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
CR_STRING = [[%pCR%s]]
CR_STRING_2 = [[%p%d]]
-- ATTRIBUTES = "attributes"
-- ID = "id"
-- CHILDREN = "children"

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
    if isTabletopObject then
        setupObjectXmlUI()
    end
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
end

function addPlayerToggle()
    if UI.getAttribute(addAPlayerID, "text") == "Open Player Selector" then
        UI.setAttribute(addAPlayerID, "text", "Close Player Selector")
        UI.setAttribute(addAPlayerID, "color", BUTTON_COLOR_6)
        displayPcs()
    else
        UI.setAttribute(addAPlayerID, "text", "Open Player Selector")
        UI.setAttribute(addAPlayerID, "color", PROMPT_BLUE)
        closePcSelector()

    end
end

function displayPcs()
    -- for each PC, activate a button (max 10 PCs)
    for i = 1, numberOfPCs, 1 do
        -- print(pcList[i])
        name = shaveString(pcList[i])
        buttonId = "buttonId" .. tostring(i)
        UI.setAttribute(buttonId, "active", "true")
        UI.setAttribute(buttonId, "text", name)
        if isTabletopObject then
            UI.setAttribute(buttonId, "onClick", objectGuid.."/playerSelected("..name..")")
        else
            UI.setAttribute(buttonId, "onClick", "playerSelected("..name..")")
        end
        
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
        UI.setAttribute(requestSkillID, "active", "true")
        UI.setAttribute(requestSkillID, "color", SELECTED_GREY)
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
        addPlayerToggle()
        UI.setAttribute(requestInitiativeID, "color", PROMPT_BLUE)
        UI.setAttribute(requestSkillID, "color", PROMPT_BLUE)
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

-- Party skill check functions:()

function requestPartySkillCheck()
    if  pcSelectorActive then
        closePcSelector()
    end
    skillNameList = ""
    statsString = ""
    statsList = {}
    broadcastToAll("It\'s time for a skill check!")
    -- for each color, if a PC, activate that UI element to request skill
    if isNotEmpty(playerColorMap.White) then
        UI.setAttribute(whiteSkillID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Red) then
        UI.setAttribute(redSkillID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Orange) then
        UI.setAttribute(orangeSkillID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Brown) then
        UI.setAttribute(brownSkillID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Pink) then
        UI.setAttribute(pinkSkillID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Purple) then
        UI.setAttribute(purpleSkillID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Yellow) then
        UI.setAttribute(yellowSkillID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Blue) then
        UI.setAttribute(blueSkillID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Green) then
        UI.setAttribute(greenSkillID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Teal) then
        UI.setAttribute(tealSkillID, "active", "true")
    end
    UI.setAttribute(requestSkillID, "color", SELECTED_GREY)
end

function addPlayerSkill(player, skillTotal, id)
    UI.setAttribute(id, "active", "false")
    name03 = findPlayerNameFromColor(player.color)
    -- print(name03)
    addNameToPartySkillPopup(name03, skillTotal)
end

function addNameToPartySkillPopup(skillName, skillTotal)
    skillNameList = skillNameList..skillName..": "..skillTotal.."\n"
    table.insert(statsList,tonumber(skillTotal))
    UI.setAttribute(skillTextID, "text", "Party Results:\n"..skillNameList.."\nStatistics:\n["..getSkillStatistics().."]")
    UI.setAttribute(skillTextID, "active", "true")

    UI.setAttribute(openPartySkillViewerID, "active", "true")
end

function getSkillStatistics()
    
    -- get the total, mean, & median
    local sum = 0
    for _,number in pairs(statsList) do
        print("number: "..tostring(number))
        sum = sum + number
    end

    if #statsList < 2 then
        return "Total: "..tostring(sum)
    end

    local mean = sum / #(statsList)

    table.sort(statsList)
    local mid = #statsList/2
    local median = 0
    print("mid: "..tostring(mid))
    if math.floor(mid)==mid then
        median = nums[mid]
    else
        median = (statsList[math.floor(mid)]+statsList[math.ceil(mid)])/2
    end

    statsString = "Total: "..tostring(sum)..", Average: "..tostring(mean)..", Middle: "..tostring(median)
    return statsString
end

function skillPopupToggle()
    if UI.getAttribute(openPartySkillViewerID, "text") == "Open Party Skill Viewer" then
        UI.setAttribute(openPartySkillViewerID, "text", "Close Party Skill Viewer")
        UI.setAttribute(openPartySkillViewerID, "color", BUTTON_COLOR_6)
        UI.setAttribute(skillTextID, "active", "true")
        UI.setAttribute(requestSkillID, "color", SELECTED_GREY)
    else
        UI.setAttribute(openPartySkillViewerID, "text", "Open Party Skill Viewer")
        UI.setAttribute(openPartySkillViewerID, "color", PROMPT_BLUE)
        UI.setAttribute(skillTextID, "active", "false")
        UI.setAttribute(requestSkillID, "color", PROMPT_BLUE)
    end
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
    if isCharacterNpc(nextPlayer) then
        nextPlayer = cutOutCRtext(nextPlayer)
    end
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
    -- print("CR str: " .. CR_STRING..", name: "..str)
    p, q = str:find(CR_STRING)
    r, s = str:find(CR_STRING_2)
    if r ~= nil then -- numbered npc, add the number
        local stringA = string.sub(str, 1, p-1)
        local stringB = string.sub(str, r+1, string.len(str))
        str = stringA..stringB
    else -- un-numbered npc
        str = string.sub(str, 1, p-2) -- cut off the space too
    end
    -- print("non CR str: "..str)
    return str
end

-- Object XML Utility functions:

function setupObjectXmlUI()
    objectGuid = "guid1234"-- getGUID()
    local newXML = replaceXmlGuid(XML_STRING, objectGuid)
    UI.setXml(newXML)
end

function replaceXmlGuid(xml, guid)
    print("XML: "..xml)
    print("GUID: "..guid)
    xml = xml:gsub("guidPlaceholder", guid)
    print("New XML: "..xml)
    return xml
end


-- Recursive XML functions:

-- characters = {"Sam", "Frodo", "Bilbo", "Gandalf", "Saruman"}

-- function getElementByIdFromRoot(root, id)
--     for _,childTable in pairs(root) do
--         local table = childTable
--         local foundElement = getElementById(table, id)
--         if foundElement != nil then 
--             return foundElement
--         end
--     end
--     return nil
-- end

-- function getElementById(xmlTable, id)
--     local parentTable = xmlTable

--     if parentTable[ATTRIBUTES] != nil and parentTable[ATTRIBUTES][ID] != nil and parentTable[ATTRIBUTES][ID] == id then
--         return parentTable

--     else
--             if type(parentTable[CHILDREN]) == "table" then
--                 for _, childTable in pairs(parentTable[CHILDREN]) do
--                     parentTable = childTable
--                     local foundElement = getElementById(parentTable,id)
--                     if foundElement != nil then
--                         return foundElement
--                     end
--                 end  
--             end

--     end

--     return nil
-- end

-- function buildInitiativeRow(fullInitiativeOrder)
--     UI.setAttribute(turnOrderID, "active", "true")

--     local gottenElement = getElementByIdFromRoot(UI.getXmlTable() , "nestedInnerPanelLeft")

--     broadcastToAll(gottenElement[ATTRIBUTES][ID])
--     --we have to locate the xml element that will contain 
    
--     -- now populate the xml:


--     for _, characterName in ipairs(fullInitiativeOrder) do
--         broadcastToAll(characterName)
--     end
-- end
